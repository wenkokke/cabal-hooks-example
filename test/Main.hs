{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Text (Text)
import Language.Prolog.Syntax
import Test.HUnit
import Test.HUnit.Text

main :: IO ()
main =
    runTestTTAndExit . TestList $
        [ TestLabel "simpsons" $
            TestCase $
                parseDatabase simpsons @?= Right simpsonsAst
        , TestLabel "small" $
            TestCase $
                parseDatabase small @?= Right smallAst
        ]

--------------------------------------------------------------------------------
-- Example Prolog Databases
--------------------------------------------------------------------------------

simpsons :: Text
simpsons =
    "child(bart,homer).\
    \child(homer,abe).\
    \child(maggie,homer).\
    \grandchild(X,Y) :-\
    \    child(X,Z),\
    \    child(Z,Y)."

small :: Text
small =
    "append([],Ys,Ys).\
    \append([X|Xs],Ys,[X|Zs]) :-\
    \    append(Xs,Ys,Zs)."

--------------------------------------------------------------------------------
-- Example ASTs
--------------------------------------------------------------------------------

simpsonsAst :: Database
simpsonsAst =
    Db
        (Just (1, 1))
        [ Fact
            (Just (1, 1))
            ( CPred
                (Just (1, 1))
                (Atm (Just (1, 1)) (LIdent "child"))
                [ TAtom (Just (1, 7)) (Atm (Just (1, 7)) (LIdent "bart"))
                , TAtom (Just (1, 12)) (Atm (Just (1, 12)) (LIdent "homer"))
                ]
            )
        , Fact
            (Just (1, 19))
            ( CPred
                (Just (1, 19))
                (Atm (Just (1, 19)) (LIdent "child"))
                [ TAtom (Just (1, 25)) (Atm (Just (1, 25)) (LIdent "homer"))
                , TAtom (Just (1, 31)) (Atm (Just (1, 31)) (LIdent "abe"))
                ]
            )
        , Fact
            (Just (1, 36))
            ( CPred
                (Just (1, 36))
                ( Atm
                    (Just (1, 36))
                    (LIdent "child")
                )
                [ TAtom (Just (1, 42)) (Atm (Just (1, 42)) (LIdent "maggie"))
                , TAtom (Just (1, 49)) (Atm (Just (1, 49)) (LIdent "homer"))
                ]
            )
        , Rule
            (Just (1, 56))
            ( CPred
                (Just (1, 56))
                (Atm (Just (1, 56)) (LIdent "grandchild"))
                [ VarT (Just (1, 67)) (V (Just (1, 67)) (UIdent "X"))
                , VarT (Just (1, 69)) (V (Just (1, 69)) (UIdent "Y"))
                ]
            )
            [ CPred
                (Just (1, 78))
                (Atm (Just (1, 78)) (LIdent "child"))
                [ VarT (Just (1, 84)) (V (Just (1, 84)) (UIdent "X"))
                , VarT (Just (1, 86)) (V (Just (1, 86)) (UIdent "Z"))
                ]
            , CPred
                (Just (1, 93))
                (Atm (Just (1, 93)) (LIdent "child"))
                [ VarT (Just (1, 99)) (V (Just (1, 99)) (UIdent "Z"))
                , VarT (Just (1, 101)) (V (Just (1, 101)) (UIdent "Y"))
                ]
            ]
        ]

smallAst :: Database
smallAst =
    Db
        (Just (1, 1))
        [ Fact
            (Just (1, 1))
            ( CPred
                (Just (1, 1))
                (Atm (Just (1, 1)) (LIdent "append"))
                [ TList
                    (Just (1, 8))
                    (Empty (Just (1, 8)))
                , VarT (Just (1, 11)) (V (Just (1, 11)) (UIdent "Ys"))
                , VarT (Just (1, 14)) (V (Just (1, 14)) (UIdent "Ys"))
                ]
            )
        , Rule
            (Just (1, 18))
            ( CPred
                (Just (1, 18))
                (Atm (Just (1, 18)) (LIdent "append"))
                [ TList
                    (Just (1, 25))
                    ( ConsV
                        (Just (1, 25))
                        [ VarT (Just (1, 26)) (V (Just (1, 26)) (UIdent "X"))
                        ]
                        (V (Just (1, 28)) (UIdent "Xs"))
                    )
                , VarT (Just (1, 32)) (V (Just (1, 32)) (UIdent "Ys"))
                , TList
                    (Just (1, 35))
                    ( ConsV
                        (Just (1, 35))
                        [ VarT (Just (1, 36)) (V (Just (1, 36)) (UIdent "X"))
                        ]
                        (V (Just (1, 38)) (UIdent "Zs"))
                    )
                ]
            )
            [ CPred
                (Just (1, 49))
                (Atm (Just (1, 49)) (LIdent "append"))
                [ VarT (Just (1, 56)) (V (Just (1, 56)) (UIdent "Xs"))
                , VarT (Just (1, 59)) (V (Just (1, 59)) (UIdent "Ys"))
                , VarT (Just (1, 62)) (V (Just (1, 62)) (UIdent "Zs"))
                ]
            ]
        ]
