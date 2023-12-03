package mirante

import scalafx.Includes._
import scalafx.application.JFXApp3
import scalafx.geometry.Insets
import scalafx.scene.Scene
import scalafx.scene.effect.DropShadow
import scalafx.scene.layout.HBox
import scalafx.scene.paint.*
import scalafx.scene.paint.Color.*
import scalafx.scene.text.Text

import scala.language.implicitConversions
import scalafx.scene.shape.Rectangle

object App extends JFXApp3:
  type JavaColor = javafx.scene.paint.Paint
  override def start(): Unit =
    stage = new JFXApp3.PrimaryStage:
      title = "mirante"
      scene = new Scene:
        fill = Color.rgb(38, 38, 38)
        content = new HBox:
          padding = Insets(50, 80, 50, 80)
          children = Seq(
            new Text:
              text = "mirante"
              style = "-fx-font: normal bold 40pt sans-serif"
              fill = new LinearGradient(endX = 0, stops = Stops(Purple, White))
            ,
            new Text:
              text = ".edu"
              style = "-fx-font: italic bold 40pt sans-serif"
              fill <== when(hover).choose[JavaColor] (White) otherwise (Purple)
              // fill = new LinearGradient(endX = 0, stops = Stops(White, DarkGray))
              effect = new DropShadow:
                color = Black
                radius = 15
                spread = 0.25
            ,
            new Rectangle:
              x = 25
              y = 40
              width = 10
              height = 10
              fill = White
            )
