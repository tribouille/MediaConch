<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mc="https://mediaarea.net/mediaconch" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" extension-element-prefixes="xsi">
    <xsl:output encoding="UTF-8" method="html" version="1.0" indent="yes"/>
    <xsl:template match="/mc:MediaConch/mc:policyChecks">
        <h1><xsl:value-of select="title"/></h1>
        <p><xsl:value-of select="description"/></p>
        <xsl:for-each select="mc:media">
            <b><xsl:value-of select="@ref"/></b><p/>
            <xsl:for-each select="mc:policy">
                <i><xsl:value-of select="@title"/></i>
                <table border="1">
                    <p>Context (field): <xsl:value-of select="mc:context/@field"/></p>
                    <p>Context (value): <xsl:value-of select="mc:context/@value"/></p>
                    <th>
                        <td>tracktype</td>
                        <td>streamid</td>
                        <td>actual</td>
                        <td>outcome</td>
                        <td>reason</td>
                    </th>
                    <xsl:for-each select="mc:test">
                        <tr>
                            <td/>
                            <td><xsl:value-of select="@tracktype"/></td>
                            <td><xsl:value-of select="@streamid"/></td>
                            <td><xsl:value-of select="@actual"/></td>
                            <td><xsl:value-of select="@outcome"/></td>
                            <td><xsl:value-of select="@reason"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
