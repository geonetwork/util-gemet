#!/bin/sh
export GEONETWORK_HOME=../develop/web/target/geonetwork
export CLASSPATH=.:$GEONETWORK_HOME/WEB-INF/lib/xml-apis-1.3.04.jar:$GEONETWORK_HOME/WEB-INF/lib/xercesImpl-2.7.1.jar:$GEONETWORK_HOME/WEB-INF/lib/xalan-2.7.1.jar:$GEONETWORK_HOME/WEB-INF/lib/serializer-2.7.1.jar

echo "Downloading INSPIRE theme thesaurus:"
wget --output-document=inspire-in.rdf http://rdfdata.eionet.europa.eu/inspirethemes/send_all

echo "Creating thesaurus ..."
java org.apache.xalan.xslt.Process -IN inspire-in.rdf -XSL inspire-theme.xsl -OUT inspire-theme.rdf

mv inspire-theme.rdf thesauri/.
rm *.rdf
echo "Done."
