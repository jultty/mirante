import cats.effect._
import org.http4s._
import org.http4s.dsl.io._

val hello = HttpRoutes.of[IO] {
  case GET -> Root / "hello" / name =>
    Ok(s"Hello, $name.")
}

@main def start =
  print_environment_properties
