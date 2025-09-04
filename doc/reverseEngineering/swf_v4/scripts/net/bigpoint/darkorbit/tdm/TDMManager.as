package net.bigpoint.darkorbit.tdm
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.TimeFormatter;
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Expo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.InfoField;
   import net.bigpoint.darkorbit.gui.elements.ScoreElement;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ServerCommands;
   
   public class TDMManager
   {
      
      private var main:Main;
      
      private var tdmTimer:Timer;
      
      private var localSecsElapsed:int;
      
      private var tdmTimeInSecs:int;
      
      private var leftFactionBitmap:Bitmap;
      
      private var rightFactionBitmap:Bitmap;
      
      private var tdmCounter:TDMCounter;
      
      private var leftScoreElement:ScoreElement;
      
      private var rightScoreElement:ScoreElement;
      
      private var homeFactionId:int;
      
      private var guestFactionId:int;
      
      private var playersLeftHome:int;
      
      private var playersLeftGuest:int;
      
      private var tdmIntroInit:Boolean = false;
      
      public function TDMManager(param1:Main)
      {
         super();
         this.main = param1;
      }
      
      public function parseCommands(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         switch(param1[3])
         {
            case ServerCommands.DRAFT:
               _loc2_ = parseInt(param1[4]);
               _loc3_ = parseInt(param1[5]);
               this.updateTDMWindow(_loc2_,_loc3_);
               if(_loc2_ == 0 && _loc3_ == -1)
               {
                  this.main.getGuiManager().writeToLog(BPLocale.getText("tdm_pull_phase_finished"));
               }
               else if(_loc2_ == 1)
               {
                  this.main.getGuiManager().writeToLog(BPLocale.getText("tdm_pull_phase"));
               }
               break;
            case ServerCommands.GAMES_COUNT:
               _loc4_ = parseInt(param1[4]);
               this.setTDMGamesCount(_loc4_);
               break;
            case ServerCommands.MESSAGE:
               _loc5_ = param1[4];
               _loc6_ = param1[5];
               _loc7_ = param1[6];
               this.main.getGuiManager().writeToLog(BPLocale.getText(_loc5_).replace(_loc6_,_loc7_));
               break;
            case ServerCommands.GATE_MAPS_MESSAGE:
               _loc8_ = param1[4];
               _loc9_ = int(param1[5]);
               this.setTDMQueue(_loc8_,_loc9_);
               break;
            case ServerCommands.TDM_EVENT:
               switch(param1[4])
               {
                  case ServerCommands.TDM_STATS_INIT:
                     _loc10_ = int(param1[5]);
                     _loc11_ = int(param1[6]);
                     this.initStats(_loc10_,_loc11_);
                     break;
                  case ServerCommands.TDM_INTRO_PHASE:
                     _loc12_ = int(param1[5]);
                     this.updateIntro(_loc12_);
                     break;
                  case ServerCommands.TDM_KICK_OFF:
                     break;
                  case ServerCommands.TDM_MATCH_RESULT:
                     _loc13_ = int(param1[5]);
                     _loc14_ = int(param1[6]);
                     _loc15_ = int(param1[7]);
                     this.updateMatchResult(-1,_loc13_,_loc14_);
                     this.showResult(_loc15_);
                     break;
                  default:
                     _loc12_ = int(param1[4]);
                     _loc13_ = int(param1[5]);
                     _loc14_ = int(param1[6]);
                     this.updateMatchResult(_loc12_,_loc13_,_loc14_);
               }
         }
      }
      
      private function createTDMWindow() : SimpleWindow
      {
         var _loc6_:SimpleElement = null;
         var _loc1_:int = 0;
         var _loc2_:SimpleWindow = this.main.getGuiManager().createWindow(SimpleWindow.WINDOW_CLASS_TDM);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_TDM);
         var _loc4_:Array = _loc3_.getAllElements();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc6_.x = _loc1_;
            _loc1_ += 60;
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function setTimeInSec(param1:int) : void
      {
         this.tdmTimeInSecs = param1;
         if(this.tdmTimer != null)
         {
            this.stopTDMTimer();
         }
         this.tdmTimer = new Timer(1000,0);
         this.tdmTimer.addEventListener(TimerEvent.TIMER,this.handleTDMTimerTick);
         this.tdmTimer.start();
         this.localSecsElapsed = 1;
      }
      
      public function updateTDMWindow(param1:int, param2:int) : void
      {
         var _loc3_:SimpleWindow = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TDM);
         if(_loc3_ == null)
         {
            _loc3_ = this.createTDMWindow();
         }
         var _loc4_:SimpleContainer = _loc3_.getContainer(SimpleContainer.CLASS_TDM);
         var _loc5_:SimpleElement = _loc4_.getElement(SimpleElement.TYPE_TDM_TIMER);
         var _loc6_:SimpleElement = _loc4_.getElement(SimpleElement.TYPE_TDM_GAMES);
         var _loc7_:SimpleElement = _loc4_.getElement(SimpleElement.TYPE_TDM_QUEUE);
         switch(param1)
         {
            case 0:
               InfoField(_loc5_).updateTooltip(BPLocale.getText("ttip_tdmTimer_1"));
               if(param2 == -1)
               {
                  this.stopTDMTimer();
                  this.setTDMTimer(0);
               }
               else
               {
                  this.setTimeInSec(param2);
                  this.setTDMTimer(param2);
               }
               if(this.leftScoreElement != null && this.rightScoreElement != null)
               {
                  if(this.leftScoreElement.visible && this.rightScoreElement.visible)
                  {
                     this.leftScoreElement.visible = false;
                     this.rightScoreElement.visible = false;
                  }
               }
               if(!_loc6_.visible && !_loc7_.visible)
               {
                  _loc6_.visible = true;
                  _loc7_.visible = true;
               }
               break;
            case 1:
               InfoField(_loc5_).updateTooltip(BPLocale.getText("ttip_tdmTimer_2"));
               this.setTDMGamesCount(0);
               this.setTDMQueue("---",0);
               if(this.leftScoreElement != null && this.rightScoreElement != null)
               {
                  if(!this.leftScoreElement.visible && !this.rightScoreElement.visible)
                  {
                     this.leftScoreElement.visible = true;
                     this.rightScoreElement.visible = true;
                  }
               }
               if(_loc6_.visible && _loc7_.visible)
               {
                  _loc6_.visible = false;
                  _loc7_.visible = false;
               }
         }
      }
      
      private function handleTDMTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:int = this.tdmTimeInSecs - this.localSecsElapsed++;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ == 0 && this.tdmTimer != null)
         {
            this.stopTDMTimer();
         }
         this.setTDMTimer(_loc2_);
      }
      
      private function stopTDMTimer() : void
      {
         this.tdmTimer.stop();
         this.tdmTimer.removeEventListener(TimerEvent.TIMER,this.handleTDMTimerTick);
      }
      
      private function removeTextFieldPulse() : void
      {
         var _loc1_:SimpleWindow = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TDM);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_TDM);
         var _loc3_:SimpleElement = _loc2_.getElement(SimpleElement.TYPE_TDM_TIMER);
         InfoField(_loc3_).removeTextfieldPulse();
      }
      
      private function setTDMTimer(param1:int) : void
      {
         var _loc3_:SimpleContainer = null;
         var _loc4_:SimpleElement = null;
         var _loc2_:SimpleWindow = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TDM);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getContainer(SimpleContainer.CLASS_TDM);
            _loc4_ = _loc3_.getElement(SimpleElement.TYPE_TDM_TIMER);
            if(_loc4_ != null)
            {
               InfoField(_loc4_).setLabel(TimeFormatter.formatTime(param1));
               if(param1 == 30)
               {
                  InfoField(_loc4_).setTextfieldPulse(0.5);
               }
               else if(param1 == 0)
               {
                  this.removeTextFieldPulse();
               }
            }
         }
      }
      
      public function setTDMGamesCount(param1:int) : void
      {
         var _loc3_:SimpleContainer = null;
         var _loc4_:SimpleElement = null;
         var _loc2_:SimpleWindow = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TDM);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getContainer(SimpleContainer.CLASS_TDM);
            _loc4_ = _loc3_.getElement(SimpleElement.TYPE_TDM_GAMES);
            if(_loc4_ != null)
            {
               InfoField(_loc4_).setLabel(param1.toString());
            }
         }
      }
      
      public function setTDMQueue(param1:String, param2:int) : void
      {
         var _loc4_:SimpleContainer = null;
         var _loc5_:SimpleElement = null;
         var _loc6_:String = null;
         var _loc3_:SimpleWindow = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TDM);
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.getContainer(SimpleContainer.CLASS_TDM);
            _loc5_ = _loc4_.getElement(SimpleElement.TYPE_TDM_QUEUE);
            _loc6_ = "cbInfoIcon_queue";
            switch(param2)
            {
               case 1:
                  _loc6_ = "cbInfoIcon_bad_queue";
                  break;
               case 2:
                  _loc6_ = "cbInfoIcon_normal_queue";
                  break;
               case 3:
                  _loc6_ = "cbInfoIcon_good_queue";
            }
            InfoField(_loc5_).updateIcon(ResourceManager.getBitmap("ui",_loc6_));
            InfoField(_loc5_).setLabel(param1.toString());
         }
      }
      
      public function initStats(param1:int, param2:int) : void
      {
         this.homeFactionId = param1;
         this.guestFactionId = param2;
      }
      
      public function showIntro() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.leftFactionBitmap = _loc1_.getEmbededBitmap("left_" + this.homeFactionId);
         this.rightFactionBitmap = _loc1_.getEmbededBitmap("right_" + this.guestFactionId);
         var _loc2_:Sprite = this.main.screenManager.getGUILayer0();
         this.tdmCounter = new TDMCounter(this);
         this.leftFactionBitmap.alpha = 0;
         this.leftFactionBitmap.x = -this.leftFactionBitmap.width;
         var _loc3_:int = ScreenManager.getHalfScreenWidth() - this.leftFactionBitmap.width - this.tdmCounter.width * 0.5 + 5;
         this.leftFactionBitmap.y = ScreenManager.getHalfScreenHeight() - 235;
         this.rightFactionBitmap.alpha = 0;
         this.rightFactionBitmap.x = ScreenManager.getScreenWidth() + this.leftFactionBitmap.width - 5;
         var _loc4_:int = ScreenManager.getHalfScreenWidth() + this.tdmCounter.width * 0.5;
         this.rightFactionBitmap.y = ScreenManager.getHalfScreenHeight() - 235;
         _loc2_.addChild(this.tdmCounter);
         _loc2_.addChild(this.leftFactionBitmap);
         _loc2_.addChild(this.rightFactionBitmap);
         TweenLite.to(this.tdmCounter,1,{"alpha":1});
         TweenLite.to(this.leftFactionBitmap,1,{
            "alpha":1,
            "x":_loc3_,
            "ease":Bounce.easeOut
         });
         TweenLite.to(this.rightFactionBitmap,1,{
            "alpha":1,
            "x":_loc4_,
            "ease":Bounce.easeOut
         });
         var _loc5_:Timer = new Timer(270,1);
         _loc5_.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleIntroCollisionFinish);
         _loc5_.start();
      }
      
      public function removeIntro() : void
      {
         var _loc1_:Sprite = this.main.screenManager.getGUILayer0();
         if(_loc1_.contains(this.leftFactionBitmap))
         {
            TweenLite.to(this.leftFactionBitmap,1,{
               "ease":Expo.easeOut,
               "alpha":0,
               "x":-this.leftFactionBitmap.width,
               "onComplete":this.handleIntroElementFadeOut,
               "onCompleteParams":[this.leftFactionBitmap]
            });
         }
         if(_loc1_.contains(this.rightFactionBitmap))
         {
            TweenLite.to(this.rightFactionBitmap,1,{
               "ease":Expo.easeOut,
               "alpha":0,
               "x":ScreenManager.getScreenWidth() + this.leftFactionBitmap.width - 5,
               "onComplete":this.handleIntroElementFadeOut,
               "onCompleteParams":[this.rightFactionBitmap]
            });
         }
         if(_loc1_.contains(this.tdmCounter))
         {
            TweenLite.to(this.tdmCounter,1,{
               "alpha":0,
               "onComplete":this.handleIntroElementFadeOut,
               "onCompleteParams":[this.tdmCounter]
            });
         }
      }
      
      private function handleIntroElementFadeOut(param1:DisplayObject) : void
      {
         var _loc2_:Sprite = this.main.screenManager.getGUILayer0();
         _loc2_.removeChild(param1);
         this.tdmIntroInit = false;
      }
      
      private function handleIntroCollisionFinish(param1:TimerEvent) : void
      {
         AudioManager.playSoundEffect(26);
         this.main.screenManager.shakeScreen();
      }
      
      public function updateIntro(param1:int) : void
      {
         if(this.tdmIntroInit)
         {
            return;
         }
         this.showIntro();
         this.tdmIntroInit = true;
         if(this.tdmCounter != null)
         {
            this.tdmCounter.startCounter(param1);
         }
      }
      
      public function updateMatchResult(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SimpleWindow = null;
         var _loc5_:SimpleContainer = null;
         this.playersLeftHome = param2;
         this.playersLeftGuest = param3;
         if(this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TDM) == null)
         {
            this.createTDMWindow();
         }
         if(this.leftScoreElement == null && this.rightScoreElement == null)
         {
            _loc4_ = this.main.getGuiManager().getWindow(SimpleWindow.WINDOW_CLASS_TDM);
            _loc5_ = _loc4_.getContainer(SimpleContainer.CLASS_TDM);
            _loc5_.getElement(SimpleElement.TYPE_TDM_GAMES).visible = false;
            _loc5_.getElement(SimpleElement.TYPE_TDM_QUEUE).visible = false;
            this.leftScoreElement = new ScoreElement(SimpleElement.TYPE_TDM_LEFT_SCORE,this.main.getGuiManager(),this.homeFactionId);
            this.leftScoreElement.x = 70;
            this.leftScoreElement.y = -5;
            this.leftScoreElement.mouseEnabled = false;
            this.rightScoreElement = new ScoreElement(SimpleElement.TYPE_TDM_RIGHT_SCORE,this.main.getGuiManager(),this.guestFactionId);
            this.rightScoreElement.x = this.leftScoreElement.x + this.leftScoreElement.getBackground().width;
            this.rightScoreElement.y = -5;
            this.rightScoreElement.mouseEnabled = false;
            _loc5_.addElement(this.leftScoreElement,SimpleContainer.NO_ALIGN);
            _loc5_.addElement(this.rightScoreElement,SimpleContainer.NO_ALIGN);
         }
         else
         {
            this.leftScoreElement.visible = true;
            this.rightScoreElement.visible = true;
         }
         this.leftScoreElement.updateScore(param2);
         this.rightScoreElement.updateScore(param3);
         this.setTDMTimer(param1);
      }
      
      public function showResult(param1:int) : void
      {
         if(param1 != -1)
         {
            switch(param1)
            {
               case 0:
                  this.main.screenManager.showBigMessage(BPLocale.getText("tdm_both_teams_lose"));
                  break;
               case 1:
                  if(Hero.factionID == this.homeFactionId)
                  {
                     this.main.screenManager.showBigMessage(BPLocale.getText("tdm_your_team_wins").replace("%COUNT%",this.playersLeftHome));
                  }
                  else
                  {
                     this.main.screenManager.showBigMessage(BPLocale.getText("tdm_your_team_loses").replace("%COUNT%",this.playersLeftGuest));
                  }
                  break;
               case 2:
                  if(Hero.factionID == this.guestFactionId)
                  {
                     this.main.screenManager.showBigMessage(BPLocale.getText("tdm_your_team_wins").replace("%COUNT%",this.playersLeftGuest));
                  }
                  else
                  {
                     this.main.screenManager.showBigMessage(BPLocale.getText("tdm_your_team_loses").replace("%COUNT%",this.playersLeftHome));
                  }
            }
         }
      }
      
      public function getMain() : Main
      {
         return this.main;
      }
      
      public function cleanUp() : void
      {
         if(this.tdmTimer != null)
         {
            this.stopTDMTimer();
         }
      }
   }
}

