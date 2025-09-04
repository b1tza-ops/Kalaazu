package net.bigpoint.darkorbit.achievement
{
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import fl.containers.ScrollPane;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.pattern.AchievementPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AchievementManager
   {
      
      public static const logger:ILogger = Log.getLogger("AchievementManager");
      
      private var simpleContainer:SimpleContainer;
      
      private var scrollPane:ScrollPane;
      
      private var guiManager:GuiManager;
      
      public var achievements:Array = [];
      
      private var order:int = 0;
      
      private var updateBufferList:Array = [];
      
      private var scrollPanePaddingY:int = 0;
      
      public function AchievementManager(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
      }
      
      public function getOrder() : int
      {
         return this.order++;
      }
      
      public function removeAchievementWindow() : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_ACHIEVMENT);
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(SimpleWindow.ON_RESIZE,this.onResizeAchievementWindow);
            _loc1_.removeEventListener(SimpleWindow.ON_RESIZED,this.guiManager.handleWindowResized);
            _loc1_.removeEventListener(SimpleWindow.ON_MAXIMIZE_CLICKED,this.handleMaximizeClicked);
            _loc1_.removeEventListener(SimpleWindow.ON_MAXIMIZED,this.handleMaximized);
            _loc2_ = new Array();
            for(_loc3_ in this.achievements)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc5_ = parseInt(_loc2_[_loc4_]);
               this.removeAchievement(_loc5_);
               _loc4_++;
            }
            this.guiManager.closeWindow(_loc1_);
            this.simpleContainer = null;
            this.scrollPane = null;
         }
      }
      
      private function createAchievementWindow() : SimpleWindow
      {
         var _loc1_:SimpleWindow = this.guiManager.createWindow(SimpleWindow.WINDOW_CLASS_ACHIEVMENT);
         _loc1_.maxWindowHeight = 460;
         _loc1_.minWindowHeight = 150;
         var _loc2_:Rectangle = new Rectangle(460,0,0,500);
         _loc1_.setResizementBounds(_loc2_);
         _loc1_.addEventListener(SimpleWindow.ON_RESIZE,this.onResizeAchievementWindow);
         _loc1_.addEventListener(SimpleWindow.ON_RESIZED,this.guiManager.handleWindowResized);
         _loc1_.addEventListener(SimpleWindow.ON_MAXIMIZE_CLICKED,this.handleMaximizeClicked);
         _loc1_.addEventListener(SimpleWindow.ON_MAXIMIZED,this.handleMaximized);
         this.simpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_DEFAULT);
         this.scrollPanePaddingY = 16;
         var _loc3_:Bitmap = ResourceManager.getBitmap("achievement","info_background.png");
         _loc3_.x = 15;
         _loc3_.y = 38;
         this.scrollPanePaddingY += _loc3_.y;
         _loc1_.getRootContainer().addChild(_loc3_);
         var _loc4_:TextField = new TextField();
         var _loc5_:TextFormat = new TextFormat(Styles.plainBigFmt.font,Styles.plainStdFontHeight,16777215);
         _loc5_.align = TextFormatAlign.LEFT;
         _loc4_.defaultTextFormat = _loc5_;
         _loc4_.embedFonts = Styles.plainStdEmbed;
         _loc4_.wordWrap = true;
         _loc4_.multiline = true;
         _loc4_.antiAliasType = AntiAliasType.ADVANCED;
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.selectable = false;
         _loc4_.width = _loc3_.width - 32 - 4;
         _loc4_.text = BPLocale.getText("achievement_header");
         _loc3_.height = _loc4_.height + 10;
         this.scrollPanePaddingY += _loc3_.height;
         _loc4_.x = _loc3_.x + 4;
         _loc4_.y = 38 + 4;
         _loc1_.getRootContainer().addChild(_loc4_);
         this.scrollPane = new ScrollPane();
         this.scrollPane.source = this.simpleContainer;
         this.scrollPane.move(_loc3_.x,_loc3_.y + _loc3_.height);
         _loc1_.getRootContainer().addChild(this.scrollPane);
         return _loc1_;
      }
      
      private function handleMaximizeClicked(param1:Event) : void
      {
         var _loc2_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_ACHIEVMENT);
         this.guiManager.stopFlashWindowIcon(_loc2_.classID);
      }
      
      private function handleMaximized(param1:Event) : void
      {
         TweenMax.delayedCall(0.5,this.checkUpdateBuffer);
      }
      
      private function checkUpdateBuffer() : void
      {
         var _loc1_:UpdateBuffer = null;
         if(this.updateBufferList.length > 0)
         {
            _loc1_ = this.updateBufferList.shift();
            this.updateAchievement(_loc1_.achievementID,_loc1_.achievementDone,_loc1_.bargainState);
         }
      }
      
      private function handleBtnClick(param1:MouseEvent) : void
      {
      }
      
      private function onResizeAchievementWindow(param1:Event) : void
      {
         var _loc2_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_ACHIEVMENT);
         if(_loc2_ != null && this.scrollPane != null)
         {
            this.scrollPane.setSize(450,_loc2_.getWindow().height - this.scrollPanePaddingY);
            this.scrollPane.refreshPane();
         }
      }
      
      public function setAchievement(param1:int, param2:Boolean, param3:int) : void
      {
         var _loc4_:AchievementElement = this.getAchievement(param1);
         if(_loc4_ == null)
         {
            this.addAchievement(param1,-1,param2,param3);
         }
         else
         {
            this.updateAchievement(param1,param2,param3);
         }
      }
      
      public function addAchievement(param1:int, param2:int, param3:Boolean, param4:int) : AchievementElement
      {
         var _loc5_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_ACHIEVMENT);
         if(_loc5_ == null)
         {
            _loc5_ = this.createAchievementWindow();
            this.loadAchievementPrices();
         }
         var _loc6_:AchievementElement = new AchievementElement(this.guiManager.getMain().getConnectionManager(),param1,param2,param3,param4);
         var _loc7_:AchievementPattern = PatternManager.achievementPatterns[param1];
         var _loc8_:String = _loc7_.languageKey;
         _loc6_.setAchievementText("achievement_" + _loc8_ + "_header","achievement_" + _loc8_ + "_directive");
         _loc6_.setRewardText("achievement_" + _loc8_ + "_reward");
         _loc6_.setTooltip("achievement_" + _loc8_ + "_tooltip");
         this.simpleContainer.addElement(_loc6_,0,0);
         this.achievements.push(_loc6_);
         this.scrollPane.setSize(450,200);
         this.scrollPane.invalidate();
         this.scrollPane.refreshPane();
         _loc5_.refreshMask();
         return _loc6_;
      }
      
      public function removeAchievement(param1:int) : void
      {
         var _loc2_:AchievementElement = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.achievements.length)
         {
            _loc2_ = this.achievements[_loc3_];
            if(_loc2_.achievementID == param1)
            {
               this.achievements.splice(_loc3_,1);
               _loc2_.cleanup();
               this.simpleContainer.removeElement(_loc2_);
               break;
            }
            _loc3_++;
         }
      }
      
      private function getAchievement(param1:int) : AchievementElement
      {
         var _loc3_:AchievementElement = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.achievements.length)
         {
            _loc3_ = this.achievements[_loc2_];
            if(_loc3_.achievementID == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function updateAchievement(param1:int, param2:Boolean, param3:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:AchievementElement = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:AchievementElement = null;
         var _loc11_:AchievementElement = null;
         var _loc12_:int = 0;
         var _loc13_:AchievementElement = null;
         var _loc14_:int = 0;
         var _loc4_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_ACHIEVMENT);
         var _loc5_:AchievementElement = this.getAchievement(param1);
         if(_loc5_.bargainState == param3 && _loc5_.achievementDone == param2)
         {
            return;
         }
         if(_loc4_ != null)
         {
            if(!_loc4_.isMaximized())
            {
               this.updateBufferList.push(new UpdateBuffer(param1,param2,param3));
               AudioManager.playSoundEffect(51);
               this.guiManager.flashWindowIcon(_loc4_.classID,-1,false);
               return;
            }
            _loc6_ = 0;
            while(_loc6_ < this.achievements.length)
            {
               _loc11_ = this.achievements[_loc6_];
               _loc11_.order = -1;
               _loc6_++;
            }
            _loc7_ = this.achievements[0];
            if(_loc7_.achievementDone)
            {
               _loc7_.order = AchievementPattern.MAX_ID - 1;
            }
            _loc8_ = _loc5_.questID;
            _loc9_ = _loc5_.achievementDone;
            this.removeAchievement(param1);
            _loc10_ = this.addAchievement(param1,_loc8_,_loc9_,param3);
            _loc10_.y = _loc5_.y;
            if(!_loc9_ && param2)
            {
               _loc10_.activate();
               _loc10_.order = 0;
               _loc12_ = 1;
               _loc14_ = 0;
               while(_loc14_ < this.achievements.length)
               {
                  _loc13_ = this.achievements[_loc14_];
                  if(_loc13_.order == -1)
                  {
                     _loc13_.order = _loc12_;
                     _loc12_++;
                  }
                  _loc14_++;
               }
               this.resortAchievements();
               TweenLite.to(this.scrollPane,1,{"verticalScrollPosition":0});
            }
            else if(_loc9_ && !param2)
            {
               _loc10_.deactivate();
            }
            if(param2)
            {
               AudioManager.playSoundEffect(51);
               if(!_loc4_.isMaximized())
               {
                  this.guiManager.flashWindowIcon(_loc4_.classID,-1,false);
               }
            }
         }
      }
      
      private function resortAchievements() : void
      {
         var _loc3_:AchievementElement = null;
         this.achievements.sortOn("order",Array.NUMERIC);
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.achievements.length)
         {
            _loc3_ = this.achievements[_loc2_];
            _loc3_.y = _loc1_;
            _loc1_ += 72;
            _loc2_++;
         }
         this.invalidateScrollPane();
      }
      
      private function invalidateScrollPane() : void
      {
         this.scrollPane.invalidate();
         this.scrollPane.refreshPane();
      }
      
      public function loadAchievementPrices() : void
      {
         var _loc1_:URLRequest = new URLRequest(Settings.dynamicHost + "flashinput/dynamicPaymentItems.php");
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.handleAchievementPricesXMLLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.handleXMLLoadingError);
         _loc2_.load(_loc1_);
      }
      
      private function handleAchievementPricesXMLLoaded(param1:Event) : void
      {
         var xml:XML = null;
         var item:XML = null;
         var achievementID:int = 0;
         var priceValue:Number = NaN;
         var priceCurrency:String = null;
         var achievementPattern:AchievementPattern = null;
         var achievement:AchievementElement = null;
         var event:Event = param1;
         try
         {
            xml = XML(event.currentTarget.data);
         }
         catch(e:Error)
         {
         }
         for each(item in xml.achievements.item)
         {
            achievementID = int(item.@id);
            priceValue = Number(item.@price);
            priceCurrency = item.@currency;
            achievementPattern = PatternManager.achievementPatterns[achievementID];
            if(achievementPattern != null)
            {
               achievementPattern.priceValue = priceValue;
               achievementPattern.priceCurrency = priceCurrency;
            }
            achievement = this.getAchievement(achievementID);
            achievement.updatePriceField();
         }
      }
      
      private function handleXMLLoadingError(param1:IOErrorEvent) : void
      {
      }
   }
}

