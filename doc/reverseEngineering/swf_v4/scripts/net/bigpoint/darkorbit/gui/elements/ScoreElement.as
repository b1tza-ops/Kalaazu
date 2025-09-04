package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   
   public class ScoreElement extends SimpleElement
   {
      
      public static var COMPANY_TYPE_MMO:int = 1;
      
      public static var COMPANY_TYPE_EIC:int = 2;
      
      public static var COMPANY_TYPE_VRU:int = 3;
      
      protected var guiManager:GuiManager;
      
      protected var companyID:int;
      
      private var background:BitmapData;
      
      private var tfCompany:TextField;
      
      private var tfScore:TextField;
      
      public function ScoreElement(param1:int, param2:GuiManager, param3:int)
      {
         super(param1);
         this.guiManager = param2;
         this.companyID = param3;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         if(getID() == TYPE_SPACEBALL_SCORE)
         {
            this.background = _loc1_.getEmbededBitmapData("spaceball_" + this.companyID);
         }
         else if(getID() == TYPE_INVASION_SCORE)
         {
            this.background = _loc1_.getEmbededBitmapData("invasion_" + this.companyID);
         }
         else if(getID() == TYPE_CTB_SCORE)
         {
            this.background = _loc1_.getEmbededBitmapData("ctb_" + this.companyID);
         }
         else if(getID() == TYPE_TDM_LEFT_SCORE)
         {
            this.background = _loc1_.getEmbededBitmapData("tdm_scoreboard_left_" + this.companyID);
         }
         else if(getID() == TYPE_TDM_RIGHT_SCORE)
         {
            this.background = _loc1_.getEmbededBitmapData("tdm_scoreboard_right_" + this.companyID);
         }
         this.addChild(new Bitmap(this.background));
         this.tfCompany = new TextField();
         this.tfCompany.defaultTextFormat = Styles.spaceballScoreFmt;
         this.tfCompany.embedFonts = Styles.spaceballScoreEmbed;
         this.tfCompany.antiAliasType = AntiAliasType.ADVANCED;
         this.tfCompany.mouseEnabled = false;
         this.tfCompany.selectable = false;
         this.tfCompany.width = this.background.width;
         this.tfCompany.height = Styles.spaceballScoreFontHeight + 5;
         this.tfCompany.multiline = false;
         this.tfCompany.y = 1;
         switch(this.companyID)
         {
            case COMPANY_TYPE_MMO:
               this.tfCompany.text = "MMO";
               break;
            case COMPANY_TYPE_EIC:
               this.tfCompany.text = "EIC";
               break;
            case COMPANY_TYPE_VRU:
               this.tfCompany.text = "VRU";
         }
         this.addChild(this.tfCompany);
         this.tfScore = new TextField();
         this.tfScore.defaultTextFormat = Styles.spaceballScoreFmt;
         this.tfScore.embedFonts = Styles.spaceballScoreEmbed;
         this.tfScore.antiAliasType = AntiAliasType.ADVANCED;
         this.tfScore.mouseEnabled = false;
         this.tfScore.selectable = false;
         this.tfScore.width = this.background.width;
         this.tfScore.height = Styles.spaceballScoreFontHeight + 5;
         this.tfScore.multiline = false;
         this.tfScore.y = 13;
         this.addChild(this.tfScore);
      }
      
      public function updateScore(param1:Number) : void
      {
         this.tfScore.text = BPLocale.roundInteger(param1);
      }
      
      public function getBackground() : BitmapData
      {
         return this.background;
      }
      
      public function getCompanyID() : int
      {
         return this.companyID;
      }
      
      public function setTitleYPosition(param1:int) : void
      {
         this.tfCompany.y = param1;
      }
      
      public function setScoreYPosition(param1:int) : void
      {
         this.tfScore.y = param1;
      }
      
      public function getGuiManager() : GuiManager
      {
         return this.guiManager;
      }
   }
}

