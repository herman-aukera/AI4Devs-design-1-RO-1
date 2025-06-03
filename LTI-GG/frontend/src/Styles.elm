module Styles exposing (..)

import Css exposing (..)
import Css.Global
import Html.Styled as Html
import Html.Styled.Attributes as Attr

-- Global styles (reset, base)
global : Css.Global.Snippet
global =
    Css.Global.body
        [ margin (px 0)
        , padding (px 0)
        , fontFamily sansSerif
        , backgroundColor (hex "#f8fafc")
        ]

-- Container for main layout
container : List (Html.Attribute msg)
container =
    [ Attr.css
        [ maxWidth (px 700)
        , margin2 (px 40) auto
        , padding2 (px 32) (px 24)
        , backgroundColor (hex "#fff")
        , borderRadius (px 12)
        , boxShadow3 (px 0) (px 2) (rgba 0 0 0 0.07)
        ]
    ]

-- Headings
h1 : List (Html.Attribute msg)
h1 =
    [ Attr.css
        [ fontSize (px 32)
        , fontWeight bold
        , color (hex "#22223b")
        , marginBottom (px 16)
        ]
    ]

h2 : List (Html.Attribute msg)
h2 =
    [ Attr.css
        [ fontSize (px 22)
        , fontWeight bold
        , color (hex "#4a4e69")
        , marginTop (px 24)
        , marginBottom (px 8)
        ]
    ]

-- Buttons
button : List (Html.Attribute msg)
button =
    [ Attr.css
        [ backgroundColor (hex "#fd4f00")
        , color (hex "#fff")
        , borderRadius (px 6)
        , borderStyle none
        , borderWidth zero
        , padding2 (px 10) (px 20)
        , fontWeight bold
        , fontSize (px 16)
        , cursor pointer
        , marginRight (px 10)
        , marginBottom (px 8)
        , property "transition" "background 0.2s, box-shadow 0.2s"
        , hover [ backgroundColor (hex "#d84315") ]
        , focus [ boxShadow3 (px 0) (px 0) (rgba 0 0 0 0.10), outline none ]
        ]
    ]

-- Error and success
errorText : List (Html.Attribute msg)
errorText =
    [ Attr.css [ color (hex "#d90429"), fontWeight bold, marginTop (px 12) ] ]

successText : List (Html.Attribute msg)
successText =
    [ Attr.css [ color (hex "#008000"), fontWeight bold, marginTop (px 12) ] ]

-- List items
listItem : List (Html.Attribute msg)
listItem =
    [ Attr.css [ padding2 (px 8) (px 0), borderBottom3 (px 1) solid (hex "#eee") ] ]

-- Form fields
input : List (Html.Attribute msg)
input =
    [ Attr.css
        [ border3 (px 1) solid (hex "#ccc")
        , borderRadius (px 6)
        , padding2 (px 10) (px 12)
        , fontSize (px 16)
        , marginBottom (px 12)
        , width (pct 100)
        , focus [ borderColor (hex "#fd4f00"), outline none ]
        ]
    ]

label : List (Html.Attribute msg)
label =
    [ Attr.css [ fontWeight bold, marginBottom (px 4), display block ] ]

sectionBg : List (Html.Attribute msg)
sectionBg =
    [ Attr.css [ backgroundColor (hex "#f3f4f6"), borderRadius (px 8), padding2 (px 16) (px 16), boxShadow3 (px 0) (px 1) (rgba 0 0 0 0.04) ] ]
