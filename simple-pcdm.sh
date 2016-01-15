echo "====Cleaning up===="
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/sColl
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/sColl/fcr:tombstone

# Simple PCDM construction without membership overrides
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/sColl
# Designate as a cdr:Collection?
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/sColl/sFolder

echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/fcr:metadata

# Create an aggregate object
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg

echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/fcr:metadata

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file0
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file1
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file2

echo "PREFIX pcdm: <http://pcdm.org/models#> PREFIX cdr: <http://cdr.lib.unc.edu#> INSERT { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file0> . <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file1> . <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file2> . <> cdr:primaryObject <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file0> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/fcr:metadata

curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file0/data-file
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page1.jpg 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file1/data-file
curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page2.jpg 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file2/data-file

echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasFile <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file0/data-file> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file0/fcr:metadata

echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasFile <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file1/data-file> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file1/fcr:metadata

echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasFile <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file2/data-file> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file2/fcr:metadata

curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file0/data-file/fcr:metadata

curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file1/data-file/fcr:metadata

curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sAgg/file2/data-file/fcr:metadata

echo "====Creating a simple file object===="
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple

echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/fcr:metadata

curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/data-file
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/data-file/fcr:metadata

echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasFile <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/data-file> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/fcr:metadata

echo "Adding MODS metadata"
curl -is -X PUT -H "Content-Type: text/xml" --data-binary @mods.xml 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/desc-mods
curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @desc-file.ru 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/desc-mods/fcr:metadata
echo "PREFIX ore: <http://www.openarchives.org/ore/terms/> INSERT { <> ore:aggregates <http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/desc-mods> } WHERE {}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sFolder/sSimple/fcr:metadata


# echo "====Move testing===="
# curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/sColl/sDest/
# echo "PREFIX pcdm: <http://pcdm.org/models#>
# INSERT { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sDest> } WHERE {}
# " | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/fcr:metadata
#
# echo
# echo "Move folder to destination"
# curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/sColl/sDest/sFolder" http://127.0.0.1:8080/fcrepo/rest/sColl/sFolder/
# echo "PREFIX pcdm: <http://pcdm.org/models#>
# DELETE { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sDest/sFolder> } WHERE {}
# " | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/fcr:metadata
# echo
# echo "PREFIX pcdm: <http://pcdm.org/models#>
# INSERT { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/sDest/sFolder> } WHERE {}
# " | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/sDest/fcr:metadata
#
# curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/sColl/file1" http://127.0.0.1:8080/fcrepo/rest/sColl/sDest/sFolder/sAgg/file1/
# echo "PREFIX pcdm: <http://pcdm.org/models#>
# DELETE { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/file1> } WHERE {}
# " | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- http://127.0.0.1:8080/fcrepo/rest/sColl/sDest/sFolder/sAgg/fcr:metadata
# echo "PREFIX pcdm: <http://pcdm.org/models#>
# INSERT { <> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/sColl/file1> } WHERE {}
# " | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/sColl/fcr:metadata