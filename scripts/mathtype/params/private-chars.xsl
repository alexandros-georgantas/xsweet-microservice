<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" exclude-result-prefixes="xs" version="3.0">

  <!-- Private Unicode characters -->
  <xsl:param name="map-private-to-unicode">
    <charmap private-hex='0020'>&#x00A0;</charmap>
    <charmap private-hex='E901'>&#x2A72;</charmap>
    <charmap private-hex='E902'>&#x2A71;</charmap>
    <charmap private-hex='E903'>&#x2A26;</charmap>
    <charmap private-hex='E904'>&#x2A24;</charmap>
    <charmap private-hex='E90B'>&#x2287;</charmap>
    <charmap private-hex='E90C'>&#x2286;</charmap>
    <charmap private-hex='E922'>&#x22DA;</charmap>
    <charmap private-hex='E924'>&#x2A6A;</charmap>
    <charmap private-hex='E924'>&#x223B;</charmap>
    <charmap private-hex='E92D'>&#x22DB;</charmap>
    <charmap private-hex='E932'>&#x2272;</charmap>
    <charmap private-hex='E933'>&#x2273;</charmap>
    <charmap private-hex='E93A'>&#x227E;</charmap>
    <charmap private-hex='E93B'>&#x227F;</charmap>
    <charmap private-hex='E98F'>&#x00B7;</charmap>
    <charmap private-hex='E98F'>&#x2270;</charmap>
    <charmap private-hex='EA07'>&#x2271;</charmap>
    <!-- NEITHER SUPERSET OF NOR EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA0B'>&#x2289;</charmap>
    <!-- NEITHER SUPERSET OF NOR EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA0B'>&#x2289;</charmap>
    <!-- NEITHER SUBSET OF NOR EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA0C'>&#x2288;</charmap>
    <!-- NEITHER SUBSET OF NOR EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA0C'>&#x2288;</charmap>
    <!-- LESS-THAN BUT NOT APPROXIMATELY EQUAL TO -->
    <charmap private-hex='EA32'>&#x2A89;</charmap>
    <!-- LESS-THAN BUT NOT APPROXIMATELY EQUAL TO -->
    <charmap private-hex='EA32'>&#x2A89;</charmap>
    <!-- GREATER-THAN BUT NOT APPROXIMATELY EQUAL TO -->
    <charmap private-hex='EA33'>&#x2A8A;</charmap>
    <!-- GREATER-THAN BUT NOT APPROXIMATELY EQUAL TO -->
    <charmap private-hex='EA33'>&#x2A8A;</charmap>
    <!-- LESS-THAN OR NOT EQUAL TO (SINGLE) -->
    <charmap private-hex='EA34'>&#x2268;</charmap>
    <!-- LESS-THAN OR NOT EQUAL TO (SINGLE) -->
    <charmap private-hex='EA34'>&#x2268;</charmap>
    <!-- GREATER-THAN OR NOT EQUAL TO (SINGLE) -->
    <charmap private-hex='EA35'>&#x2269;</charmap>
    <!-- GREATER-THAN OR NOT EQUAL TO (SINGLE) -->
    <charmap private-hex='EA35'>&#x2269;</charmap>
    <!-- PRECEDES BUT NOT EQUIVALENT TO (DOUBLE) -->
    <charmap private-hex='EA3A'>&#x22E8;</charmap>
    <!-- PRECEDES BUT NOT EQUIVALENT TO (DOUBLE) -->
    <charmap private-hex='EA3A'>&#x22E8;</charmap>
    <!-- SUCCEEDS BUT NOT EQUIVALENT TO (DOUBLE) -->
    <charmap private-hex='EA3B'>&#x22E9;</charmap>
    <!-- SUCCEEDS BUT NOT EQUIVALENT TO (DOUBLE) -->
    <charmap private-hex='EA3B'>&#x22E9;</charmap>
    <!-- PRECEDES BUT NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA40'>&#x2AB5;</charmap>
    <!-- PRECEDES BUT NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA40'>&#x2AB5;</charmap>
    <!-- SUCCEEDS BUT NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA41'>&#x2AB6;</charmap>
    <!-- SUCCEEDS BUT NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA41'>&#x2AB6;</charmap>
    <!-- NOT SUBSET OF NOR EQUAL TO -->
    <charmap private-hex='EA42'>&#x2288;</charmap>
    <!-- NOT SUBSET OF NOR EQUAL TO -->
    <charmap private-hex='EA42'>&#x2288;</charmap>
    <!-- NOT SUPERSET OF NOR EQUAL TO -->
    <charmap private-hex='EA43'>&#x2289;</charmap>
    <!-- NOT SUPERSET OF NOR EQUAL TO -->
    <charmap private-hex='EA43'>&#x2289;</charmap>
    <!-- SUBSET OF OR NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA44'>&#x228A;</charmap>
    <!-- SUBSET OF OR NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA44'>&#x228A;</charmap>
    <!-- SUPERSET OF OR NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA45'>&#x228B;</charmap>
    <!-- SUPERSET OF OR NOT EQUAL TO (DOUBLE) -->
    <charmap private-hex='EA45'>&#x228B;</charmap>
    <!-- RIGHTWARDS ARROW ABOVE SHORT LEFTWARDS ARROW -->
    <charmap private-hex='EB01'>&#x2942;</charmap>
    <!-- SHORT RIGHTWARDS ARROW ABOVE LEFTWARDS ARROW -->
    <charmap private-hex='EB02'>&#x2944;</charmap>
    <!-- DOUBLE ARROW NORTHEAST SOUTHWEST -->
    <charmap private-hex='EB05'>&#x2922;</charmap>
    <!-- DOUBLE ARROW NORTHWEST SOUTHEAST -->
    <charmap private-hex='EB06'>&#x2921;</charmap>
    <!-- COMBINING TILDE TWO SPACE -->
    <charmap private-hex='EE04'>&#x02DC;</charmap>
    <!-- COMBINING TILDE THREE SPACE -->
    <charmap private-hex='EE05'>&#x02DC;</charmap>
    <!-- COMBINING TILDE FOUR SPACE -->
    <charmap private-hex='EE06'>&#x02DC;</charmap>
    <!-- COMBINING CIRCUMFLEX TWO SPACE -->
    <charmap private-hex='EE07'>&#x005E;</charmap>
    <!-- COMBINING CIRCUMFLEX THREE SPACE -->
    <charmap private-hex='EE08'>&#x005E;</charmap>
    <!-- COMBINING CIRCUMFLEX FOUR SPACE -->
    <charmap private-hex='EE09'>&#x005E;</charmap>
    <!-- COMBINING ARC TWO SPACE -->
    <charmap private-hex='EE0A'>&#x2322;</charmap>
    <!-- COMBINING ARC THREE SPACE -->
    <charmap private-hex='EE0B'>&#x2322;</charmap>
    <!-- COMBINING ARC FOUR SPACE -->
    <charmap private-hex='EE0C'>&#x2322;</charmap>
    <!-- QUADRUPLE PRIME -->
    <charmap private-hex='EE19'>&#x2057;</charmap>
    <!-- QUADRUPLE PRIME -->
    <charmap private-hex='EE19'>&#x2057;</charmap>
    <!-- ALIGNMENT MARK -->
    <charmap private-hex='EF00'><malignmark/></charmap>
    <!-- ALIGNMENT MARK -->
    <charmap private-hex='EF00'><malignmark/></charmap>
    <!-- MT ZERO SPACE -->
    <charmap private-hex='EF01'>&#x200B;</charmap>
    <!-- MT ZERO SPACE -->
    <charmap private-hex='EF01'>&#x200B;</charmap>
    <!-- MT THIN SPACE -->
    <charmap private-hex='EF02'>&#x2009;</charmap>
    <!-- MT THIN SPACE -->
    <charmap private-hex='EF02'>&#x2009;</charmap>
    <!-- MT MEDIUM SPACE -->
    <charmap private-hex='EF03'>&#x205F;</charmap>
    <!-- MT MEDIUM SPACE -->
    <charmap private-hex='EF03'>&#x205F;</charmap>
    <!-- MT THICK SPACE -->
    <charmap private-hex='EF04'>&#x2009;</charmap>
    <!-- MT THICK SPACE -->
    <charmap private-hex='EF04'>&#x2009;</charmap>
    <!-- MT EM SPACE -->
    <charmap private-hex='EF05'>&#x2003;</charmap>
    <!-- MT EM SPACE -->
    <charmap private-hex='EF05'>&#x2003;</charmap>
    <!-- MT 2 EM SPACE -->
    <charmap private-hex='EF06'>&#x2003;&#x2003;</charmap>
    <!-- MT 2 EM SPACE -->
    <charmap private-hex='EF06'>&#x2003;&#x2003;</charmap>
    <!-- UNSUPPORTED: range: Private Use Area -->
    <charmap private-hex='EF07'>Unsupported character</charmap>
    <!-- UNSUPPORTED: range: Private Use Area -->
    <charmap private-hex='EF07'>Unsupported character</charmap>
    <!-- MT 1 POINT SPACE -->
    <charmap private-hex='EF08'>&#x200A;</charmap>
    <!-- MT 1 POINT SPACE -->
    <charmap private-hex='EF08'>&#x200A;</charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL A -->
    <charmap private-hex='F000'><mi mathvariant='fraktur'>A</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL B -->
    <charmap private-hex='F001'><mi mathvariant='fraktur'>B</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL C -->
    <charmap private-hex='212D'>&#x212D;</charmap>
    <!-- UNSUPPORTED: range: Private Use Area -->
    <charmap private-hex='F002'>Unsupported character</charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL D -->
    <charmap private-hex='F003'><mi mathvariant='fraktur'>D</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL E -->
    <charmap private-hex='F004'><mi mathvariant='fraktur'>E</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL F -->
    <charmap private-hex='F005'><mi mathvariant='fraktur'>F</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL G -->
    <charmap private-hex='F006'><mi mathvariant='fraktur'>G</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL H -->
    <charmap private-hex='210C'>&#x210C;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F007'>Unsupported character</charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL I -->
    <charmap private-hex='2111'>&#x2111;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F008'>Unsupported character</charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL J -->
    <charmap private-hex='F009'><mi mathvariant='fraktur'>J</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL K -->
    <charmap private-hex='F00A'><mi mathvariant='fraktur'>K</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL L -->
    <charmap private-hex='F00B'><mi mathvariant='fraktur'>L</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL M -->
    <charmap private-hex='F00C'><mi mathvariant='fraktur'>M</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL N -->
    <charmap private-hex='F00D'><mi mathvariant='fraktur'>N</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL O -->
    <charmap private-hex='F00E'><mi mathvariant='fraktur'>O</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL P -->
    <charmap private-hex='F00F'><mi mathvariant='fraktur'>P</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL Q -->
    <charmap private-hex='F010'><mi mathvariant='fraktur'>Q</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL R -->
    <charmap private-hex='211C'>&#x211C;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F011'>Unsupported character</charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL S -->
    <charmap private-hex='F012'><mi mathvariant='fraktur'>S</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL T -->
    <charmap private-hex='F013'><mi mathvariant='fraktur'>T</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL U -->
    <charmap private-hex='F014'><mi mathvariant='fraktur'>U</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL V -->
    <charmap private-hex='F015'><mi mathvariant='fraktur'>V</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL W -->
    <charmap private-hex='F016'><mi mathvariant='fraktur'>W</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL X -->
    <charmap private-hex='F017'><mi mathvariant='fraktur'>X</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL Y -->
    <charmap private-hex='F018'><mi mathvariant='fraktur'>Y</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR CAPITAL Z -->
    <charmap private-hex='2128'>&#x2128;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F019'>Unsupported character</charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL A -->
    <charmap private-hex='F01A'><mi mathvariant='fraktur'>a</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL B -->
    <charmap private-hex='F01B'><mi mathvariant='fraktur'>b</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL C -->
    <charmap private-hex='F01C'><mi mathvariant='fraktur'>c</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL D -->
    <charmap private-hex='F01D'><mi mathvariant='fraktur'>d</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL E -->
    <charmap private-hex='F01E'><mi mathvariant='fraktur'>e</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL F -->
    <charmap private-hex='F01F'><mi mathvariant='fraktur'>f</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL G -->
    <charmap private-hex='F020'><mi mathvariant='fraktur'>g</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL H -->
    <charmap private-hex='F021'><mi mathvariant='fraktur'>h</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL I -->
    <charmap private-hex='F022'><mi mathvariant='fraktur'>i</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL J -->
    <charmap private-hex='F023'><mi mathvariant='fraktur'>j</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL K -->
    <charmap private-hex='F024'><mi mathvariant='fraktur'>k</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL L -->
    <charmap private-hex='F025'><mi mathvariant='fraktur'>l</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL M -->
    <charmap private-hex='F026'><mi mathvariant='fraktur'>m</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL N -->
    <charmap private-hex='F027'><mi mathvariant='fraktur'>n</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL O -->
    <charmap private-hex='F028'><mi mathvariant='fraktur'>o</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL P -->
    <charmap private-hex='F029'><mi mathvariant='fraktur'>p</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL Q -->
    <charmap private-hex='F02A'><mi mathvariant='fraktur'>q</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL R -->
    <charmap private-hex='F02B'><mi mathvariant='fraktur'>r</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL S -->
    <charmap private-hex='F02C'><mi mathvariant='fraktur'>s</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL T -->
    <charmap private-hex='F02D'><mi mathvariant='fraktur'>t</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL U -->
    <charmap private-hex='F02E'><mi mathvariant='fraktur'>u</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL V -->
    <charmap private-hex='F02F'><mi mathvariant='fraktur'>v</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL W -->
    <charmap private-hex='F030'><mi mathvariant='fraktur'>w</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL X -->
    <charmap private-hex='F031'><mi mathvariant='fraktur'>x</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL Y -->
    <charmap private-hex='F032'><mi mathvariant='fraktur'>y</mi></charmap>
    <!-- MATHEMATICAL FRAKTUR SMALL Z -->
    <charmap private-hex='F033'><mi mathvariant='fraktur'>z</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL A -->
    <charmap private-hex='F080'><mi mathvariant='double-struck'>A</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL B -->
    <charmap private-hex='F081'><mi mathvariant='double-struck'>B</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL C -->
    <charmap private-hex='2102'>&#x2102;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F082'>Unsupported character</charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL D -->
    <charmap private-hex='F083'><mi mathvariant='double-struck'>D</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL E -->
    <charmap private-hex='F084'><mi mathvariant='double-struck'>E</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL F -->
    <charmap private-hex='F085'><mi mathvariant='double-struck'>F</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL G -->
    <charmap private-hex='F086'><mi mathvariant='double-struck'>G</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL H -->
    <charmap private-hex='210D'>&#x210D;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F087'>Unsupported character</charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL I -->
    <charmap private-hex='F088'><mi mathvariant='double-struck'>I</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL J -->
    <charmap private-hex='F089'><mi mathvariant='double-struck'>J</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL K -->
    <charmap private-hex='F08A'><mi mathvariant='double-struck'>K</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL L -->
    <charmap private-hex='F08B'><mi mathvariant='double-struck'>L</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL M -->
    <charmap private-hex='F08C'><mi mathvariant='double-struck'>M</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL N -->
    <charmap private-hex='2115'>&#x2115;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F08D'>Unsupported character</charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL O -->
    <charmap private-hex='F08E'><mi mathvariant='double-struck'>O</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL P -->
    <charmap private-hex='2119'>&#x2119;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F08F'>Unsupported character</charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL Q -->
    <charmap private-hex='211A'>&#x211A;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F090'>Unsupported character</charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL R -->
    <charmap private-hex='211D'>&#x211D;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F091'>Unsupported character</charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL S -->
    <charmap private-hex='F092'><mi mathvariant='double-struck'>S</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL T -->
    <charmap private-hex='F093'><mi mathvariant='double-struck'>T</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL U -->
    <charmap private-hex='F094'><mi mathvariant='double-struck'>U</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL V -->
    <charmap private-hex='F095'><mi mathvariant='double-struck'>V</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL W -->
    <charmap private-hex='F096'><mi mathvariant='double-struck'>W</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL X -->
    <charmap private-hex='F097'><mi mathvariant='double-struck'>X</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL Y -->
    <charmap private-hex='F098'><mi mathvariant='double-struck'>Y</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK CAPITAL Z -->
    <charmap private-hex='2124'>&#x2124;</charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F099'>Unsupported character</charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL A -->
    <charmap private-hex='F09A'><mi mathvariant='double-struck'>a</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL B -->
    <charmap private-hex='F09B'><mi mathvariant='double-struck'>b</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL C -->
    <charmap private-hex='F09C'><mi mathvariant='double-struck'>c</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL D -->
    <charmap private-hex='F09D'><mi mathvariant='double-struck'>d</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL E -->
    <charmap private-hex='F09E'><mi mathvariant='double-struck'>e</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL F -->
    <charmap private-hex='F09F'><mi mathvariant='double-struck'>f</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL G -->
    <charmap private-hex='F0A0'><mi mathvariant='double-struck'>g</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL H -->
    <charmap private-hex='F0A1'><mi mathvariant='double-struck'>h</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL I -->
    <charmap private-hex='F0A2'><mi mathvariant='double-struck'>i</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL J -->
    <charmap private-hex='F0A3'><mi mathvariant='double-struck'>j</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL K -->
    <charmap private-hex='F0A4'><mi mathvariant='double-struck'>k</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL L -->
    <charmap private-hex='F0A5'><mi mathvariant='double-struck'>l</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL M -->
    <charmap private-hex='F0A6'><mi mathvariant='double-struck'>m</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL N -->
    <charmap private-hex='F0A7'><mi mathvariant='double-struck'>n</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL O -->
    <charmap private-hex='F0A8'><mi mathvariant='double-struck'>o</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL P -->
    <charmap private-hex='F0A9'><mi mathvariant='double-struck'>p</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL Q -->
    <charmap private-hex='F0AA'><mi mathvariant='double-struck'>q</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL R -->
    <charmap private-hex='F0AB'><mi mathvariant='double-struck'>r</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL S -->
    <charmap private-hex='F0AC'><mi mathvariant='double-struck'>s</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL T -->
    <charmap private-hex='F0AD'><mi mathvariant='double-struck'>t</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL U -->
    <charmap private-hex='F0AE'><mi mathvariant='double-struck'>u</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL V -->
    <charmap private-hex='F0AF'><mi mathvariant='double-struck'>v</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL W -->
    <charmap private-hex='F0B0'><mi mathvariant='double-struck'>w</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL X -->
    <charmap private-hex='F0B1'><mi mathvariant='double-struck'>x</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL Y -->
    <charmap private-hex='F0B2'><mi mathvariant='double-struck'>y</mi></charmap>
    <!-- MATHEMATICAL DOUBLE-STRUCK SMALL Z -->
    <charmap private-hex='F0B3'><mi mathvariant='double-struck'>z</mi></charmap>
    <!-- BLACKBOARD-BOLD DIGIT ZERO -->
    <charmap private-hex='F0C0'>
    <mn mathvariant='double-struck'>0</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT ONE -->
    <charmap private-hex='F0C1'>
    <mn mathvariant='double-struck'>1</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT TWO -->
    <charmap private-hex='F0C2'>
    <mn mathvariant='double-struck'>2</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT THREE -->
    <charmap private-hex='F0C3'>
    <mn mathvariant='double-struck'>3</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT FOUR -->
    <charmap private-hex='F0C4'>
    <mn mathvariant='double-struck'>4</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT FIVE -->
    <charmap private-hex='F0C5'>
    <mn mathvariant='double-struck'>5</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT SIX -->
    <charmap private-hex='F0C6'>
    <mn mathvariant='double-struck'>6</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT SEVEN -->
    <charmap private-hex='F0C7'>
    <mn mathvariant='double-struck'>7</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT EIGHT -->
    <charmap private-hex='F0C8'>
    <mn mathvariant='double-struck'>8</mn></charmap>
    <!-- BLACKBOARD-BOLD DIGIT NINE -->
    <charmap private-hex='F0C9'>
    <mn mathvariant='double-struck'>9</mn></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL A -->
    <charmap private-hex='F100'><mi mathvariant='script'>A</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL B -->
    <charmap private-hex='212C'><mi mathvariant='script'>B</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL B -->
    <charmap private-hex='F101'><mi mathvariant='script'>B</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F101'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL C -->
    <charmap private-hex='F102'><mi mathvariant='script'>C</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL D -->
    <charmap private-hex='F103'><mi mathvariant='script'>D</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL E -->
    <charmap private-hex='2130'><mi mathvariant='script'>E</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL E -->
    <charmap private-hex='F104'><mi mathvariant='script'>E</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F104'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL F -->
    <charmap private-hex='2131'><mi mathvariant='script'>F</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL F -->
    <charmap private-hex='F105'><mi mathvariant='script'>F</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F105'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL G -->
    <charmap private-hex='F106'><mi mathvariant='script'>G</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL H -->
    <charmap private-hex='210B'><mi mathvariant='script'>H</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL H -->
    <charmap private-hex='F107'><mi mathvariant='script'>H</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F107'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL I -->
    <charmap private-hex='2110'><mi mathvariant='script'>I</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL I -->
    <charmap private-hex='F108'><mi mathvariant='script'>I</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F108'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL J -->
    <charmap private-hex='F109'><mi mathvariant='script'>J</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL K -->
    <charmap private-hex='F10A'><mi mathvariant='script'>K</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL L -->
    <charmap private-hex='2112'><mi mathvariant='script'>L</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL L -->
    <charmap private-hex='F10B'><mi mathvariant='script'>L</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F10B'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL M -->
    <charmap private-hex='2133'><mi mathvariant='script'>M</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL M -->
    <charmap private-hex='F10C'><mi mathvariant='script'>M</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F10C'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL N -->
    <charmap private-hex='F10D'><mi mathvariant='script'>N</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL O -->
    <charmap private-hex='F10E'><mi mathvariant='script'>O</mi></charmap>
    <!-- Weierstrass Elliptic Function -->
    <charmap private-hex='2118'>&#x2118;</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL P -->
    <charmap private-hex='2118'>&#x1D4AB;</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL P -->
    <charmap private-hex='F10F'><mi mathvariant='script'>P</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F10F'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL Q -->
    <charmap private-hex='F110'><mi mathvariant='script'>Q</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL R -->
    <charmap private-hex='211B'><mi mathvariant='script'>R</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL R -->
    <charmap private-hex='F111'><mi mathvariant='script'>R</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F111'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL S -->
    <charmap private-hex='F112'><mi mathvariant='script'>S</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL T -->
    <charmap private-hex='F113'><mi mathvariant='script'>T</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL U -->
    <charmap private-hex='F114'><mi mathvariant='script'>U</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL V -->
    <charmap private-hex='F115'><mi mathvariant='script'>V</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL W -->
    <charmap private-hex='F116'><mi mathvariant='script'>W</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL X -->
    <charmap private-hex='F117'><mi mathvariant='script'>X</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL Y -->
    <charmap private-hex='F118'><mi mathvariant='script'>Y</mi></charmap>
    <!-- MATHEMATICAL SCRIPT CAPITAL Z -->
    <charmap private-hex='F119'><mi mathvariant='script'>Z</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL A -->
    <charmap private-hex='F11A'><mi mathvariant='script'>a</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL B -->
    <charmap private-hex='F11B'><mi mathvariant='script'>b</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL C -->
    <charmap private-hex='F11C'><mi mathvariant='script'>c</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL D -->
    <charmap private-hex='F11D'><mi mathvariant='script'>d</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL E -->
    <charmap private-hex='F11E'><mi mathvariant='script'>e</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL E -->
    <charmap private-hex='212F'><mi mathvariant='script'>e</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F11E'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT SMALL F -->
    <charmap private-hex='F11F'><mi mathvariant='script'>f</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL G -->
    <charmap private-hex='210A'><mi mathvariant='script'>g</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL G -->
    <charmap private-hex='F120'><mi mathvariant='script'>g</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F120'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT SMALL H -->
    <charmap private-hex='F121'><mi mathvariant='script'>h</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL I -->
    <charmap private-hex='F122'><mi mathvariant='script'>i</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL J -->
    <charmap private-hex='F123'><mi mathvariant='script'>j</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL K -->
    <charmap private-hex='F124'><mi mathvariant='script'>k</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL L -->
    <charmap private-hex='2113'><mi mathvariant='script'>l</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL L -->
    <charmap private-hex='F125'><mi mathvariant='script'>l</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F125'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT SMALL M -->
    <charmap private-hex='F126'><mi mathvariant='script'>m</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL N -->
    <charmap private-hex='F127'><mi mathvariant='script'>n</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL O -->
    <charmap private-hex='2134'><mi mathvariant='script'>o</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL O -->
    <charmap private-hex='F128'><mi mathvariant='script'>o</mi></charmap>
    <!-- UNSUPPORTED -->
    <charmap private-hex='F128'>Unsupported character</charmap>
    <!-- MATHEMATICAL SCRIPT SMALL P -->
    <charmap private-hex='F129'><mi mathvariant='script'>p</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL Q -->
    <charmap private-hex='F12A'><mi mathvariant='script'>q</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL R -->
    <charmap private-hex='F12B'><mi mathvariant='script'>r</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL S -->
    <charmap private-hex='F12C'><mi mathvariant='script'>s</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL T -->
    <charmap private-hex='F12D'><mi mathvariant='script'>t</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL U -->
    <charmap private-hex='F12E'><mi mathvariant='script'>u</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL V -->
    <charmap private-hex='F12F'><mi mathvariant='script'>v</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL W -->
    <charmap private-hex='F130'><mi mathvariant='script'>w</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL X -->
    <charmap private-hex='F131'><mi mathvariant='script'>x</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL Y -->
    <charmap private-hex='F132'><mi mathvariant='script'>y</mi></charmap>
    <!-- MATHEMATICAL SCRIPT SMALL Z -->
    <charmap private-hex='F133'><mi mathvariant='script'>z</mi></charmap>
    <!-- ZERO WIDTH NO-BREAK SPACE -->
    <charmap private-hex='FEFF'>&#xFEFF;</charmap>
    <!-- DifferentialD -->
    <charmap private-hex='ED10'>&#x2146;</charmap>
    <!-- DifferentialD -->
    <charmap private-hex='ED10'>&#x2146;</charmap>
    <!-- ExponentialE -->
    <charmap private-hex='ED11'>&#x2147;</charmap>
    <!-- ExponentialE -->
    <charmap private-hex='ED11'>&#x2147;</charmap>
    <!-- ImaginaryI -->
    <charmap private-hex='ED12'>&#x2148;</charmap>
    <!-- ImaginaryI -->
    <charmap private-hex='ED12'>&#x2148;</charmap>
    <!-- ImaginaryJ -->
    <charmap private-hex='ED13'>&#x2149;</charmap>
    <!-- ImaginaryJ -->
    <charmap private-hex='ED13'>&#x2149;</charmap>
    <!-- CapitalDifferentialD -->
    <charmap private-hex='ED16'>&#x2145;</charmap>
    <!-- CapitalDifferentialD -->
    <charmap private-hex='ED16'>&#x2145;</charmap>
  </xsl:param>

</xsl:stylesheet>
