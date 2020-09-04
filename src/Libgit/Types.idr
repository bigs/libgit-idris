module Libgit.Types

import System.FFI

||| An abstract token representing the initialized libgit2 state. Its
||| constructor is purposefully not exported, a context can only be created
||| via `runGitT`.
public export
data GitContext : (i : Type) -> Type where
  MkGitContext : GitContext i

||| A simple type alias for Git results which can either return a non-zero
||| integer error code or a result.
public export
GitResult : Type -> Type
GitResult a = Either Int a

export
toGitResult : Int -> a -> GitResult a
toGitResult err x = case err < 0 of
  True => Left err
  False => Right x

||| An opaque type representing a Git repository.
public export
data GitRepository : Type where
  MkGitRepository : AnyPtr -> GitRepository

||| An opaque type representing a Git object id.
public export
data GitOid : Type where
  MkGitOid : AnyPtr -> GitOid
