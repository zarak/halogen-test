module Request
  ( component
  ) where

import Prelude

import Affjax as AX
import Affjax.ResponseFormat as AXRF
import Data.Either (hush)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Web.Event.Event (Event)
import Web.Event.Event as Event

type State =
  { loading :: Boolean
  , username :: String
  , result :: Maybe String
  }

data Action
  = SetUsername String
  | MakeRequest Event

component :: forall query input output m. MonadAff m => H.Component query input output m
component =
  H.mkComponent
  { initialState
  , render
  , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
  }

initialState :: forall input. input -> State
initialState _ = { loading: false, username: "", result: Nothing }

render :: forall m. State -> H.ComponentHTML Action () m
render state = do
  HH.form
    [ HE.onSubmit \ev -> MakeRequest ev ]
    [ HH.h1_ [ HH.text "Look up GitHub user" ]
    , HH.label_
      [ HH.div_ [HH.text "Enter username:" ]
      , HH.input
        [ HP.value state.username
        , HE.onValueInput \str -> SetUsername str
        ]
      ]
    , HH.button 
      [ HP.disabled state.loading
      , HP.type_ HP.ButtonSubmit
      ]
      [ HH.text "Fetch info" ]
    , HH.p_ 
      [ HH.text $ if state.loading then "Working..." else "" ]
    , HH.div_
      case state.result of
          Nothing -> []
          Just res ->
            [ HH.h2_
              [ HH.text "Respones:" ]
            , HH.pre_
              [ HH.code_ [ HH.text res ] ]
            ]
    ]

-- Add a MonadEffect constraint to m
handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  SetUsername username -> do
     H.modify_ _ { username = username, result = Nothing }

  MakeRequest event -> do
     H.liftEffect $ Event.preventDefault event
     username <- H.gets _.username
     H.modify_ _ { loading = true }
     response <- H.liftAff $ AX.get AXRF.string ("https://api.github.com/users/" <> username)
     H.modify_ _ { loading = false, result = map _.body (hush response) }
