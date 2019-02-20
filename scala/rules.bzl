# This file has been autogenerated by bazel-deps.
# Please, DO NOT EDIT it by hand.

load("@io_bazel_rules_scala//scala:scala.bzl", "scala_repl", native_scala_binary = "scala_binary", native_scala_library = "scala_library", native_scala_test = "scala_test")
load("//3rdparty:deps.bzl", "dependencies")

_default_scalac_jvm_flags = [
    "-Xmx1536M",
    "-Xms1536M",
    "-Xss5M",
    "-XX:MaxMetaspaceSize=512m",
]

def _distinct(items):
  return depset(items).to_list()

def _asNeverlink(label):
  if ":" in label:
    idx = label.rindex(":")
    name = label[(idx+1):]
    prefix = label[:idx]
    return "%s:%s_EXT" % (prefix,name)
  else:
    if "/" in label:
      idx = label.rindex("/") + 1
      name = label[idx:]
      return "%s:%s_EXT" % (label,name)
    else:
      return "%s_EXT" % (label)

def _asNeverlinks(labels):
  return [_asNeverlink(label) for label in labels]

def _scala_library_impl(name, srcs, deps, external, scalac_jvm_flags, visibility, neverlink, exports, **kwargs):
    allexternal = [dep
             for ext in external
             for dep in dependencies(ext, neverlink)]
    realname = ("%s_EXT" % name) if neverlink else name
    realdeps = _asNeverlinks(deps) if neverlink else deps
    realexports = _asNeverlinks(exports) if neverlink else exports
    calculated_deps = _distinct(realdeps + allexternal)
    calculated_exports = _distinct(allexternal + realexports)
    native_scala_library(
        name = realname,
        deps = calculated_deps,
        exports = calculated_exports,
        srcs = native.glob(["**/*.scala"], exclude = ["test/**/*"]) if srcs == None else srcs,
        scalac_jvm_flags = scalac_jvm_flags,
        visibility = visibility,
        **kwargs
    )

def scala_library(name, srcs = None, deps = [], external = [], exports = [], scalac_jvm_flags = _default_scalac_jvm_flags, visibility = ["//visibility:public"], **kwargs):
    _scala_library_impl(
        name             = name,                   deps       = deps,
        external         = external,               srcs       = srcs,
        scalac_jvm_flags = scalac_jvm_flags,       visibility = visibility,
        neverlink        = False,                  exports    = exports,
        **kwargs
    )
    _scala_library_impl(
        name             = name,                   deps       = deps,
        external         = external,               srcs       = srcs,
        scalac_jvm_flags = scalac_jvm_flags,       visibility = visibility,
        neverlink        = True,                   exports    = exports,
        **kwargs
    )
    allexternal = [dep
             for ext in external
             for dep in dependencies(ext, False)]
    realdeps = deps
    scala_repl(
        name             = "%s_repl" % name,
        deps             = _distinct(realdeps + allexternal + [name]),
        scalac_jvm_flags = scalac_jvm_flags,
    )

def _scala_binary_impl(name, main_class, srcs, deps, external, scalac_jvm_flags, neverlink, **kwargs):
    allexternal = [dep
             for ext in external
             for dep in dependencies(ext, neverlink)]
    realname= ("%s_EXT" % name) if neverlink else name
    native_scala_binary(
        name = realname,
        deps = _distinct(deps + allexternal),
        srcs = native.glob(["**/*.scala"], exclude = ["test/**/*"]) if srcs == None else srcs,
        scalac_jvm_flags = scalac_jvm_flags,
        main_class = main_class,
        **kwargs
    )

def scala_binary(name, main_class, srcs = None, deps = [], external = [], scalac_jvm_flags = _default_scalac_jvm_flags, **kwargs):
    _scala_binary_impl(
        name             = name,                   deps       = deps,
        external         = external,               srcs       = srcs,
        scalac_jvm_flags = scalac_jvm_flags,       main_class = main_class,
        neverlink        = False,                  **kwargs
    )
    _scala_binary_impl(
        name             = name,                   deps       = deps,
        external         = external,               srcs       = srcs,
        scalac_jvm_flags = scalac_jvm_flags,       main_class = main_class,
        neverlink        = True,                   **kwargs
    )
    _scala_library_impl(
        name = "__%s_binary_lib" % name,
        deps = deps,
        external = external,
        srcs = srcs,
        scalac_jvm_flags = scalac_jvm_flags,
        neverlink = False,
        exports = [],
        **kwargs
    )
    allexternal = [dep
             for ext in external
             for dep in dependencies(ext, False)]
    scala_repl(
        name = "%s_repl" % name,
        deps = _distinct(deps + allexternal + ["__%s_binary_lib" % name]),
        scalac_jvm_flags = scalac_jvm_flags,
    )

def scala_test(name, srcs = None, deps = [], external = [], resources = None, scalac_jvm_flags = _default_scalac_jvm_flags, **kwargs):
    allexternal = [dep
             for ext in external
             for dep in dependencies(ext, False)]
    native_scala_test(
        name = name,
        deps = _distinct(deps + allexternal),
        resources = native.glob(["test-resources/**/*"]) if resources == None else resources,
        srcs = native.glob(["test/**/*.scala"]) if srcs == None else srcs,
        scalac_jvm_flags = scalac_jvm_flags,
        **kwargs
    )
