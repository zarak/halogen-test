module Button
  ( component
  ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
-- import Halogen.HTML.Properties as HP

type State =
  { counter :: Int }

data Action =
  Increment | Decrement

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }

-- Leave the type variable open because state isn't used
initialState :: forall i. i -> State
initialState _ = { counter: 0 }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
   HH.div_
    [ HH.button [ HE.onClick \_ -> Increment  ] [ HH.text "+" ]
    , HH.button [ HE.onClick \_ -> Decrement  ] [ HH.text "-" ]
    , HH.text (show state.counter)
    ]

-- type () means there are no child components
-- o type param is used when communicating with parent component 
-- m type is a monad
-- modify_ (with the underscore) updates the state without returning it
handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  Increment ->
    H.modify_ \st -> st { counter = st.counter + 1 }
  Decrement ->
    H.modify_ \st -> st { counter = st.counter - 1 }
