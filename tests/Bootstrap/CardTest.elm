module Bootstrap.CardTest exposing (..)

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Text as Text
import Html
import Html.Attributes as Attr
import Test exposing (Test, test, describe)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class, classes, attribute)


emptySimpleCard : Test
emptySimpleCard =
    let
        html =
            Card.config []
                |> Card.view
    in
        describe "Simple card no options"
            [ test "expect card class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ classes [ "card" ] ]
            ]


cardBlock : Test
cardBlock =
    let
        html =
            Card.config [ Card.info ]
                |> Card.block
                    [ Block.attrs [ Attr.class "my-class" ]
                    , Block.align Text.alignXsCenter
                    , Block.textColor Text.dark
                    , Block.primary
                    ]
                    [ Block.titleH1 [] [ Html.text "titleh1" ]
                    , Block.text [] [ Html.text "cardtext" ]
                    , Block.link [] [ Html.text "link" ]
                    , Block.quote [] [ Html.text "blockquote" ]
                    , Block.custom <| Html.div [] [ Html.text "customel" ]
                    ]
                |> Card.view
        block =
            html
                |> Query.fromHtml
                |> Query.find [ class "card-body"]
    in
        describe "Card block with options and items"
            [ test "expect classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ classes [ "card", "bg-info" ] ]
            , test "expect title" <|
                \() ->
                    block
                        |> Query.find [ tag "h1" ]
                        |> Query.has [ class "card-title", text "titleh1" ]
            , test "expect text paragraph" <|
                \() ->
                    block
                        |> Query.find [ tag "p" ]
                        |> Query.has [ class "card-text", text "cardtext" ]
            , test "expect link" <|
                \() ->
                    block
                        |> Query.find [ tag "a" ]
                        |> Query.has [ class "card-link", text "link" ]
            , test "expect blockquote" <|
                \() ->
                    block
                        |> Query.find [ tag "blockquote" ]
                        |> Query.has [ class "card-blockquote", text "blockquote" ]
            , test "expect custom element" <|
                \() ->
                    block
                        |> Query.find [ tag "div" ]
                        |> Query.has [ text "customel" ]
            , test "expect custom attribute" <|
                \() ->
                    block
                        |> Query.has [ class "my-class" ]
            , test "expect dark color" <|
                \() ->
                    block
                        |> Query.has [ class "text-dark" ]
            , test "expect centered text" <|
                \() ->
                    block
                        |> Query.has [ class "text-center" ]
            , test "expect primary" <|
                \() ->
                    block
                        |> Query.has [ class "bg-primary" ]
            ]


cardFullMonty : Test
cardFullMonty =
    let
        html =
            Card.config
                [ Card.outlineInfo
                , Card.align Text.alignXsCenter
                , Card.attrs [ Attr.class "my-class" ]
                , Card.textColor Text.dark
                ]
                |> Card.headerH1 [] [ Html.text "Header" ]
                |> Card.footer [] [ Html.text "Footer" ]
                |> Card.imgTop [ Attr.src "/imgtop.jpg" ] []
                |> Card.imgBottom [ Attr.src "/imgbottom.jpg" ] []
                |> Card.block [] [ Block.text [] [ Html.text "cardblock" ] ]
                |> Card.view
    in
        describe "Card with everything in it"
            [ test "expect classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ classes [ "card", "border-info", "text-center" ] ]
            , test "expect card header" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "card-header" ]
                        |> Query.has [ tag "h1", text "Header" ]
            , test "expect card footer" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "card-footer" ]
                        |> Query.has [ text "Footer" ]
            , test "expect card image top" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "card-img-top" ]
                        |> Query.has [ attribute <| Attr.attribute "src" "/imgtop.jpg" ]
            , test "expect card image bottom" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "card-img-bottom" ]
                        |> Query.has [ attribute <| Attr.attribute "src" "/imgbottom.jpg" ]
            , test "expect card block" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "card-body" ]
                        |> Query.has [ text "cardblock" ]
            , test "expect custom attribute" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ class "my-class" ]
            , test "expect dark color" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ class "text-dark" ]
            ]


group : Test
group =
    let
        html =
            Card.group <| cardList 3

        keyedHtml =
            Card.keyedGroup <| keyedCardList [ "id1", "id2", "id3" ]
    in
        describe "Card group"
            [ test "expect classes" <|
                \() ->
                    expectClasses html "card-group"
            , test "expect classes (keyed)" <|
                \() ->
                    expectClasses keyedHtml "card-group"
            , test "expect 3 cards" <|
                \() ->
                    expectThreeItems html
            , test "expect 3 cards (keyed)" <|
                \() ->
                    expectThreeItems keyedHtml
            ]


deck : Test
deck =
    let
        html =
            Card.deck <| cardList 3

        keyedHtml =
            Card.keyedDeck <| keyedCardList [ "id1", "id2", "id3" ]
    in
        describe "Card deck"
            [ test "expect classes" <|
                \() ->
                    expectClasses html "card-deck"
            , test "expect classes (keyed)" <|
                \() ->
                    expectClasses keyedHtml "card-deck"
            , test "expect 3 cards" <|
                \() ->
                    expectThreeItems html
            , test "expect 3 cards (keyed)" <|
                \() ->
                    expectThreeItems keyedHtml
            ]


columns : Test
columns =
    let
        html =
            Card.columns <| cardList 3

        keyedHtml =
            Card.keyedColumns <| keyedCardList [ "id1", "id2", "id3" ]
    in
        describe "Card columns with everything in it"
            [ test "expect classes" <|
                \() ->
                    expectClasses html "card-columns"
            , test "expect classes (keyed)" <|
                \() ->
                    expectClasses keyedHtml "card-columns"
            , test "expect 3 cards" <|
                \() ->
                    expectThreeItems html
            , test "expect 3 cards (keyed)" <|
                \() ->
                    expectThreeItems keyedHtml
            ]


cardList : Int -> List (Card.Config msg)
cardList count =
    List.repeat count <|
        Card.config []


expectClasses : Html.Html msg -> String -> Expect.Expectation
expectClasses html nodeClass =
    html
        |> Query.fromHtml
        |> Query.has [ class nodeClass ]


expectThreeItems : Html.Html msg -> Expect.Expectation
expectThreeItems html =
    html
        |> Query.fromHtml
        |> Query.findAll [ class "card" ]
        |> Query.count (Expect.equal 3)


keyedCardList : List String -> List ( String, Card.Config msg )
keyedCardList ids =
    List.map (\id -> ( id, Card.config [] )) ids


listGroup : Test
listGroup =
    let
        html =
            Card.config []
                |> Card.listGroup
                    [ ListGroup.li [ ListGroup.success ] [ Html.text "item1" ]
                    , ListGroup.li [ ListGroup.info ] [ Html.text "item2" ]
                    ]
                |> Card.view
    in
    describe "Card with list group"
        [ test "expect two list items" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 2)
        ]
