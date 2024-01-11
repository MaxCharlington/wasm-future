(module
 (type $none_=>_none (func))
 (type $i32_=>_none (func (param i32)))
 (type $none_=>_i32 (func (result i32)))
 (import "wasi_snapshot_preview1" "proc_exit" (func $fimport$0 (param i32)))
 (memory $0 2)
 (export "memory" (memory $0))
 (export "_start" (func $1))
 (func $0
  (nop)
 )
 (func $1
  (local $0 i32)
  (block $label$1
   (if
    (i32.eqz
     (i32.load
      (i32.const 1024)
     )
    )
    (block
     (i32.store
      (i32.const 1024)
      (i32.const 1)
     )
     (call $0)
     (local.set $0
      (call $2)
     )
     (call $4)
     (br_if $label$1
      (local.get $0)
     )
     (return)
    )
   )
   (unreachable)
  )
  (call $3
   (local.get $0)
  )
  (unreachable)
 )
 (func $2 (result i32)
  (i32.const 6)
 )
 (func $3 (param $0 i32)
  (call $fimport$0
   (local.get $0)
  )
  (unreachable)
 )
 (func $4
  (call $0)
  (call $0)
 )
 ;; custom section "producers", size 28
)
