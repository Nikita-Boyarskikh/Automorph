<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:math="http://exslt.org/math" extension-element-prefixes="math">
  <xsl:output method="html"/>
  <xsl:template match="/">
    <h1>Автоморфные числа</h1>
    <xsl:variable name="error" select="hash/error"/>
    <xsl:variable name="result" select="hash/result/result"/>
    <xsl:choose>
      <xsl:when test="not($error/@nil)">
        <p id="error">
          <xsl:value-of select="$error"></xsl:value-of>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <table>
        <tr>
          <th>№</th>
          <th>Число</th>
          <th>Квадрат</th>
        </tr>
        <xsl:for-each select="$result">
          <tr>
            <td name="index"><xsl:value-of select="position()"></xsl:value-of></td>
            <td name="value"><xsl:value-of select="."></xsl:value-of></td>
            <td name="square"><xsl:value-of select="math:power(., 2)"></xsl:value-of></td>
          </tr>
        </xsl:for-each>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>