All tests create a single base container, which are then populated with X children containers.  Each container has two children, one of which contains a binary and the other contains another object (simply to save time since creating binaries has been found to be much slower).

For the two PCDM examples, that appears as:

pcdm:Collection
  * pcdm:hasMember => pcdm:Object
    * pcdm:hasMember => pcdm:Object
      * pcdm:hasFile => pcdm:File
      * pcdm:hasFile => pcdm:File
  * -- repeat X times --

Tests include creating objects in a container, moving them into a subcontainer, and then deleting the original base container.  The following scripts are for performance testing basic operations:
  * *-pcdm-create.sh
  * *-pcdm-move.sh
  * *-pcdm-delete.sh

no-pcdm
=======
Basic hierarchy using the Fedora 4, no PCDM relationships added.

hier-pcdm
=========
Using ldp:DirectContainers for nesting children, full PCDM membership relations and types.

flat-pcdm
=========
Using ldp:IndirectContainers for representing children relations in a flat structure, full PCDM membership relations and types.



Scripts are derived from PCDM in Action examples https://github.com/awead/ldp-pcdm