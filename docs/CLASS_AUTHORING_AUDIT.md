# Class authoring boilerplate audit

Current user-facing Odin classes are safe but still verbose. The repeated parts
that can be reduced without hiding ownership are:

- building `ClassRegistrationNames` and keeping class/parent names in stable
  process-lifetime storage
- initializing stable `RegistrationStringName` and `RegistrationString` storage
  for method, property, signal, argument, and hint metadata
- collecting method, property, and signal descriptors into fixed arrays before
  calling `class_builder_register`
- wiring the same create/free/notification callbacks into a class builder
- unregistering the class explicitly during module deinitialization

Pieces that should stay explicit for now:

- create and free callbacks, because they allocate and free extension-owned data
- notification callbacks, because they choose which virtual dispatch path is used
- instance-data allocation, attachment, and freeing
- owned `Resource`, `RefCounted`, `Variant`, `String`, `Signal`, and `Callable`
  destruction
- class unregistering during deinitialization

The next helper layer should therefore build stable descriptors from caller-owned
storage, but should not allocate hidden metadata, infer callbacks, retain objects,
or register/unregister behind implicit global state.
