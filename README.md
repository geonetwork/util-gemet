# GEMET Utility

Shell scripts to create thesaurus based on EEA RDF repository in a SKOS 
format usable in GeoNetwork opensource.

## Scripts

A script is provided to convert GEMET thesaurus https://www.eionet.europa.eu/gemet/


Use the following to generate a GEMET SKOS file with many languages:
```
./gemet-to-simpleskos.sh en fr de nl it
```

Note: Update GEONETWORK_HOME variable before running any scripts.


## Thesaurus

Some thesaurus are already available in the [thesauri](thesauri) folder:
* GEMET - Concepts, version 4.1.2


**For INSPIRE related thesaurus**, use the import from Registry function in the admin console > Classification system.


