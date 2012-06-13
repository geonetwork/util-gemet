<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:exslt="http://exslt.org/common"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:gemet="http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:ns4="http://rdfdata.eionet.europa.eu/inspirethemes/themes/"
    exclude-result-prefixes="ns4 owl">
    <!-- Convert GEMET Skos files into a simple skos structure
managed by GeoNetwork opensource.
-->

    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="debug" select="true()"/>

    <xsl:template name="header">
        <!-- Scheme -->
        <skos:ConceptScheme rdf:about="http://geonetwork-opensource.org/inspire-theme">
            <dc:title>INSPIRE themes</dc:title>
            <dc:description>INSPIRE themes thesaurus for GeoNetwork opensource.</dc:description>
            <dc:creator>
                <foaf:Organization>
                    <foaf:name>EEA</foaf:name>
                </foaf:Organization>
            </dc:creator>
            <dc:uri>http://www.eionet.europa.eu/gemet/about?langcode=en</dc:uri>
            <dc:rights>http://www.eionet.europa.eu/gemet/about?langcode=en</dc:rights>
            <dcterms:issued>Fry Sep 22 07:57:15 CEST 2009</dcterms:issued>
            <dcterms:modified>2009-09-22 07:57:15</dcterms:modified>
        </skos:ConceptScheme>
    </xsl:template>

    <xsl:template name="debug">
        <xsl:param name="msg"/>
        <xsl:param name="cd"/>

        <xsl:if test="$debug=true()">
            <xsl:message><xsl:value-of select="$cd"/>|<xsl:value-of select="$msg"/></xsl:message>
        </xsl:if>

    </xsl:template>

    <!-- Based on locales.xml -->
    <xsl:template match="/">
        <rdf:RDF>
            <xsl:call-template name="header"/>
            <xsl:for-each select="//rdf:Description[skos:prefLabel]">
                <xsl:variable name="id" select="@rdf:about"/>

                <xsl:call-template name="debug">
                    <xsl:with-param name="cd">000</xsl:with-param>
                    <xsl:with-param name="msg">Processing id:<xsl:value-of select="$id"
                        /></xsl:with-param>
                </xsl:call-template>


                <skos:Concept rdf:about="{$id}">
                    <xsl:copy-of select="skos:*"/>
                </skos:Concept>
            </xsl:for-each>
        </rdf:RDF>
    </xsl:template>
</xsl:stylesheet>
