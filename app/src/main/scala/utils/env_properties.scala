import scala.util.Properties
import build.Info

def print_environment_properties: Unit =
  println(s"${Info.name} ${Info.version} built ${Info.builtAtString}")
  println(s"Scala ${Info.scalaVersion} Library version ${Properties.versionNumberString}")
  println(
    s"${Properties.javaVmVendor} " +
    s"${Properties.javaVmName} " +
    s"${Properties.javaVmVersion} " +
    s"(${Properties.javaVmInfo})"
  )
  println(s"JDK Home: ${Properties.jdkHome}")
