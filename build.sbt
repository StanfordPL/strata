
name := "strata"

version := "1.0"

scalaVersion := "2.11.7"



libraryDependencies += "com.github.scopt" %% "scopt" % "3.3.0"

libraryDependencies += "pl.project13.scala" %% "rainbow" % "0.2"

libraryDependencies += "commons-io" % "commons-io" % "2.3"

libraryDependencies += "org.json4s" %% "json4s-native" % "3.3.0.RC6"

libraryDependencies += "org.json4s" %% "json4s-ext" % "3.3.0.RC6"

libraryDependencies += "com.github.nscala-time" %% "nscala-time" % "2.2.0"

libraryDependencies += "com.github.tototoshi" %% "scala-csv" % "1.2.2"

libraryDependencies += "com.assembla.scala-incubator" %% "graph-core" % "1.9.4"



resolvers += Resolver.sonatypeRepo("public")



scalacOptions in ThisBuild ++= Seq("-unchecked", "-deprecation", "-feature", "–Xcheck-null", "–Xfatal-warnings")
