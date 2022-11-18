import Demo

def main : IO Unit := do
  let stdout ← IO.getStdout

  stdout.putStrLn s!"double of 2 is {double 2}"

