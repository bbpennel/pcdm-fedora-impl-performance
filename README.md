To run all tests, from your fcrepo4-vagrant directory:
```
/path/to/pcdm-fedora-impl-performance/run-all.sh
or
/path/to/pcdm-fedora-impl-performance/run-increments.sh
```

Tests include creating objects in a container, reading them, moving them into a subcontainer, and then deleting the original base container.  The following scripts are for performance testing basic operations:
  * *-pcdm-create.sh
  * *-pcdm-move.sh
  * *-pcdm-delete.sh
  * *-pcdm-traverse.sh

All tests create a single base container, which is then populated with X children objects.  Each object has two children, each containing one object (representing where binaries would be located).  This case was chosen to represent our own use cases and allow us to test the various LDP scenarios.

For the PCDM examples, that appears as:

pcdm:Collection
  * pcdm:hasMember => pcdm:Object
    * pcdm:hasMember => pcdm:Object
      * pcdm:hasFile => pcdm:File
      * pcdm:hasFile => pcdm:File
  * -- repeat X times --

no-pcdm
=======
Basic hierarchy using the Fedora 4, no PCDM relationships added.  This is the control case.	

no-ldp-pcdm
===========
Fedora objects with all necessary PCDM relations are created with explicit API calls, using no other container types to populate membership relations.

hier-pcdm
=========
Using ldp:DirectContainers for nesting children, full PCDM membership relations and types.

flat-pcdm
=========
Using ldp:IndirectContainers for representing children relations in a flat structure, ldp:DirectContainers for pcdm:hasFile relations, full PCDM membership relations and types.  Based on the PCDM in Action examples and the Sufia 7 implementation.

min-no-ldp-cdm
=======
Fedora objects with all necessary PCDM relations EXCEPT for membership relations.  This case is for isolating the membership relationship creation component from the rest of PCDM.


Scripts are derived from PCDM in Action examples https://github.com/awead/ldp-pcdm