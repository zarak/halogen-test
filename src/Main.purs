module Main where

import Prelude

import Effect (Effect)
-- import Button as Button
import Random as Random
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI Random.component unit body
