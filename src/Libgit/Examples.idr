module Libgit.Examples

import Control.Monad.Managed

import Libgit

-- Clone a repository and print some information about the success of the
-- operation.
export
testClone : String -> String -> String -> IO ()
testClone url localPath branch = do
  res <- withGit $ runManaged $ do
    eRes <- repository (GitRepositoryClone (MkCloneOpts False branch) url localPath)
    let result = case eRes of
                   Left res => "Error: " ++ show res
                   Right _ => "Cloned repository"
    liftIO $ putStrLn result
  case res of
    Left err => putStrLn ("Error initializing: " ++ show err)
    Right _ => putStrLn "Success"

-- Open a repository and reset its head to a given commit/tag
export
resetRepo : (path : String) -> (rev : String) -> IO ()
resetRepo path rev = do
  withGit $ runManaged $ do
    Right repo <- repository (GitRepositoryOpen path)
      | Left err => putStrLn ("Error opening repo: " ++ show err)
    Right (objTyp ** obj) <- revParse repo rev
      | Left err => putStrLn ("Error opening repo: " ++ show err)
    case objTyp of
      GitObjectCommit => do
        liftIO (resetRepository repo obj GitResetHard)
        liftIO (putStrLn "Successfully reset repo")
      GitObjectTag => do
        liftIO (resetRepository repo obj GitResetHard)
        liftIO (putStrLn "Successfully reset repo")
      _ => liftIO (putStrLn "Wrong object type")
    putStrLn "Successfully reset repo"
  pure ()

