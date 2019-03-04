package io.iohk.scalanet.peergroup

import java.nio.ByteBuffer

import io.iohk.decco.Codec
import io.iohk.decco.PartialCodec.{DecodeResult, Failure}
import io.iohk.scalanet.messagestream.MessageStream
import org.slf4j.LoggerFactory

import scala.language.higherKinds

class MessageChannel[A, MessageType: Codec, F[_]](peerGroup: PeerGroup[A, F])(
    implicit codec: Codec[MessageType]
) {
  private val log = LoggerFactory.getLogger(getClass)

  private val subscribers = new Subscribers[MessageType]()

  private[peergroup] def handleMessage(nextIndex: Int, byteBuffer: ByteBuffer): Unit = {
    val messageE: Either[Failure, DecodeResult[MessageType]] = codec.partialCodec.decode(nextIndex, byteBuffer)
    messageE match {
      case Left(Failure) =>
        log.debug(
          s"Decode failed in typed channel for peer address '${peerGroup.processAddress}' using codec '${codec.typeCode}'"
        )
      case Right(decodeResult) =>
        log.debug(
          s"Successful decode in typed channel for peer address '${peerGroup.processAddress}' using codec '${codec.typeCode}'. Notifying subscribers."
        )
        subscribers.notify(decodeResult.decoded)
    }
  }

  val inboundMessages: MessageStream[MessageType] = subscribers.messageStream

  def sendMessage(address: A, message: MessageType): F[Unit] = {
    peerGroup.sendMessage(address, codec.encode(message))
  }
}