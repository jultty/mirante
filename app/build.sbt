val scala3Version = "3.3.1"
val http4sVersion = "0.23.24"
val slickVersion = "3.5.0-M5"

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
      "org.http4s" %% "http4s-ember-client" % http4sVersion,
      "org.http4s" %% "http4s-ember-server" % http4sVersion,
      "org.http4s" %% "http4s-dsl"          % http4sVersion,
      "com.typesafe.slick" %% "slick"       % slickVersion,
      "org.slf4j" % "slf4j-nop"             % "1.7.26",
      "org.scalameta" %% "munit"            % "0.7.29" % Test, 
    ),

  )
.enablePlugins(BuildInfoPlugin)
  .settings(
    buildInfoKeys := Seq[BuildInfoKey](name, version, scalaVersion),
    buildInfoPackage := "build",
    buildInfoObject := "Info",
    buildInfoOptions += BuildInfoOption.BuildTime,
  )
