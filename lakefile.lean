import Lake
open Lake DSL

package demo {
  -- add package configuration options here
}

lean_lib Demo {
  -- add library configuration options here
}

@[default_target]
lean_exe demo {
  root := `Main
}
