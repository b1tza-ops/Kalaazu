package net.bigpoint.darkorbit
{
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Styles
   {
      
      public static const baseEmbed:Boolean = true;
      
      public static const baseFont:String = "EurostileHeaFl";
      
      public static const corporateFontRegular:String = "EurostileFl";
      
      public static const corporateFontHeavy:String = "EurostileHeaFl";
      
      public static const h1FontHeight:int = 17;
      
      public static const h1Fmt:TextFormat = new TextFormat(corporateFontHeavy,h1FontHeight);
      
      public static const h1Embed:Boolean = true;
      
      public static const systemSplashFontHeight:int = 20;
      
      public static const systemSplashFmt:TextFormat = new TextFormat(corporateFontHeavy,systemSplashFontHeight);
      
      public static const systemSplashEmbed:Boolean = true;
      
      public static const windowTitleFontHeight:int = 14;
      
      public static const windowTitleFmt:TextFormat = new TextFormat(corporateFontHeavy,windowTitleFontHeight);
      
      public static const windowTitleEmbed:Boolean = true;
      
      public static const h2FontHeight:int = 14;
      
      public static const h2Fmt:TextFormat = new TextFormat(corporateFontHeavy,h2FontHeight);
      
      public static const h2Embed:Boolean = true;
      
      public static const h3FontHeight:int = 12;
      
      public static const h3Fmt:TextFormat = new TextFormat(corporateFontHeavy,h3FontHeight);
      
      public static const h3Embed:Boolean = true;
      
      public static const plainBigFontHeight:int = 14;
      
      public static const plainBigFmt:TextFormat = new TextFormat(corporateFontHeavy,plainBigFontHeight);
      
      public static const plainBigEmbed:Boolean = true;
      
      public static const plainStdFontHeight:int = 12;
      
      public static const plainStdFmt:TextFormat = new TextFormat(corporateFontRegular,plainStdFontHeight);
      
      public static const plainStdEmbed:Boolean = true;
      
      public static const strongStdFontHeight:int = 12;
      
      public static const strongStdFmt:TextFormat = new TextFormat(corporateFontHeavy,strongStdFontHeight);
      
      public static const strongStdEmbed:Boolean = true;
      
      public static const centeredHeavyFontHeight:int = 12;
      
      public static const centeredHeavyFmt:TextFormat = new TextFormat(corporateFontHeavy,centeredHeavyFontHeight);
      
      public static const centeredHeavyEmbed:Boolean = true;
      
      public static const tradeWindowButtonFontHeight:int = 10;
      
      public static const tradeWindowButtonFmt:TextFormat = new TextFormat(corporateFontRegular,tradeWindowButtonFontHeight,16777215);
      
      public static const tradeWindowButtonEmbed:Boolean = true;
      
      public static const tooltipFontHeight:int = 12;
      
      public static const tooltipFmt:TextFormat = new TextFormat("Tahoma",tooltipFontHeight,13421772);
      
      public static const tooltipEmbed:Boolean = false;
      
      public static const infoFieldFontHeight:int = 10;
      
      public static const infoFieldFmt:TextFormat = new TextFormat(corporateFontHeavy,infoFieldFontHeight,14671839);
      
      public static const infoFieldEmbed:Boolean = true;
      
      public static const infoFieldFixedFmt:TextFormat = new TextFormat(infoFieldFmt.font,infoFieldFmt.size,infoFieldFmt.color);
      
      public static const logFontHeight:int = 12;
      
      public static const logFmt:TextFormat = new TextFormat(corporateFontHeavy,logFontHeight,14671839);
      
      public static const logEmbed:Boolean = true;
      
      public static const achievementFontHeight:int = 11;
      
      public static const achievementFmt:TextFormat = new TextFormat(corporateFontRegular,achievementFontHeight,14671839);
      
      public static const achievementEmbed:Boolean = false;
      
      public static const achievementOfferFontHeight:int = 11;
      
      public static const achievementOfferFmt:TextFormat = new TextFormat(corporateFontRegular,achievementOfferFontHeight,14671839);
      
      public static const achievementOfferEmbed:Boolean = false;
      
      public static const simpleFontHeight:int = 14;
      
      public static const simpleFmt:TextFormat = new TextFormat(corporateFontHeavy,simpleFontHeight);
      
      public static const simpleEmbed:Boolean = true;
      
      public static const stdOffsetY:int = 0;
      
      public static const stdOffsetLogY:int = 0;
      
      public static const spaceballScoreFontHeight:int = 12;
      
      public static const spaceballScoreFmt:TextFormat = new TextFormat(corporateFontHeavy,spaceballScoreFontHeight,16777215);
      
      public static const spaceballScoreEmbed:Boolean = true;
      
      public static const nickFontHeight:int = 16;
      
      public static const nickFmt:TextFormat = new TextFormat(corporateFontHeavy,simpleFontHeight);
      
      public static const nickEmbed:Boolean = true;
      
      public static const oreTradeElementFontHeight:int = 10;
      
      public static const oreTradeElementFmt:TextFormat = new TextFormat(corporateFontHeavy,oreTradeElementFontHeight,15327936);
      
      public static const oreTradeElementEmbed:Boolean = true;
      
      public static const systemTitleFontHeight:int = 12;
      
      public static const systemTitleFmt:TextFormat = new TextFormat(corporateFontRegular,simpleFontHeight,16776960);
      
      public static const systemTitleEmbed:Boolean = true;
      
      public static const systemPermanentTitleFontHeight:int = 12;
      
      public static const systemPermanentTitleFmt:TextFormat = new TextFormat(corporateFontRegular,simpleFontHeight,14892454);
      
      public static const systemPermanentTitleEmbed:Boolean = true;
      
      systemSplashFmt.align = TextFormatAlign.CENTER;
      centeredHeavyFmt.align = TextFormatAlign.CENTER;
      infoFieldFixedFmt.align = TextFormatAlign.RIGHT;
      spaceballScoreFmt.align = TextFormatAlign.CENTER;
      
      public function Styles()
      {
         super();
      }
   }
}

