val scala3Version = "3.3.1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "seer",
    version := "0.1.0-SNAPSHOT",

    scalaVersion := scala3Version,
    fork := true,

    libraryDependencies ++= Seq(
    "org.scalameta" %% "munit" % "0.7.29" % Test, 
      "org.scalafx" %% "scalafx" % "21.0.0-R32",
    ),
  )
