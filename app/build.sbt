val scala3Version = "3.3.1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "mirante",
    version := "0.1.0",
    scalaVersion := scala3Version,

    logLevel := Level.Warn,
    watchLogLevel := Level.Warn,
    watchBeforeCommand := Watch.clearScreen,
    Global / cancelable := true,

    libraryDependencies ++= Seq(
      "org.scalameta" %% "munit" % "0.7.29" % Test, 
    ),

  )
.enablePlugins(BuildInfoPlugin)
  .settings(
    buildInfoKeys := Seq[BuildInfoKey](name, version, scalaVersion),
    buildInfoPackage := "build",
    buildInfoObject := "Info",
    buildInfoOptions += BuildInfoOption.BuildTime,
  )
