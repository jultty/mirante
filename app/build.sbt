val scala3Version = "3.3.1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "mirante",
    version := "0.1.0",

    logLevel := Level.Warn,
    watchLogLevel := Level.Warn,
    watchBeforeCommand := Watch.clearScreen,
    scalaVersion := scala3Version,
    fork := true,
    Global / cancelable := true,

    libraryDependencies ++= Seq(
    "org.scalameta" %% "munit" % "0.7.29" % Test, 
      "org.scalafx" %% "scalafx" % "21.0.0-R32",
    ),
  )
