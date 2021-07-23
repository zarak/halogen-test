module Main where

import Prelude

import Effect (Effect)
-- import Button as Button
-- import Random as Random
import Request as Request
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI Request.component unit body
