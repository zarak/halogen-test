module Random
  ( component
  ) where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Random (randomBool)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

type State = Maybe Boolean

data Action =
  Regenerate

component :: forall query input output m. MonadEffect m => H.Component query input output m
component =
  H.mkComponent
  { initialState
  , render
  , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
  }


initialState :: forall input. input -> State
initialState _ = Nothing

render :: forall m. State -> H.ComponentHTML Action () m
render state = do
  let value = maybe "No weather information available yet" showWeather state
      showWeather x = if x then "yes" else "no"
  HH.div_
    [ HH.h1_
        [ HH.text "Weather" ]
    , HH.p_
        [ HH.text ("Will it rain today? " <> value) ]
    , HH.button
        [ HE.onClick \_ -> Regenerate ]
        [ HH.text "Check weather" ]
    ]

handleAction :: forall output m. MonadEffect m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Regenerate -> do
     newBool <- H.liftEffect randomBool
     H.modify_ \_ -> Just newBool

