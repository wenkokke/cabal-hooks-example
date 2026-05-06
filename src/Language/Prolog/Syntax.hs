module Language.Prolog.Syntax (
    module Abs,
    parseDatabase,
)
where

import Data.Text (Text)
import Language.Prolog.Syntax.Abs as Abs
import Language.Prolog.Syntax.Lex (Token)
import Language.Prolog.Syntax.Par (myLexer, pDatabase)

--------------------------------------------------------------------------------
-- Parsing

type Parser a = [Token] -> Either String a

parseDatabase :: Text -> Either String Database
parseDatabase t = pDatabase (myLexer t)
