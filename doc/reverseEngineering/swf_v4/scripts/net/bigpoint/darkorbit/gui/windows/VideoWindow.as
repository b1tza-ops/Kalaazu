package net.bigpoint.darkorbit.gui.windows
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.LogMessage;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.TextAreaElement;
   import net.bigpoint.darkorbit.gui.elements.VideoElement;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class VideoWindow extends SimpleWindow
   {
      
      public static const NOTIFICATION_FPS:int = 9876;
      
      public var startX:int = 0;
      
      public var startY:int = 0;
      
      public var targetX:int = 0;
      
      public var targetY:int = 0;
      
      public var align:String = "n";
      
      public var scrollSpeed:Number = 0.5;
      
      private var simpleContainer:SimpleContainer;
      
      private var videoElement:VideoElement;
      
      private var textAreaElement:TextAreaElement;
      
      public var videoID:int;
      
      public var videoClassID:int;
      
      private var logWriter:Timer;
      
      public var languageKeys:Array = [];
      
      private var continueButton:ButtonElement;
      
      private var fasterButton:ButtonElement;
      
      private var logCharIndex:int = 0;
      
      private var noiseChannel:SoundChannel;
      
      private var logMessage:LogMessage;
      
      private var valid:Boolean;
      
      public var showButtons:Boolean;
      
      private var factionID:int;
      
      public function VideoWindow(param1:GuiManager, param2:int, param3:int, param4:int, param5:String, param6:Boolean, param7:int = 0)
      {
         super(param1,param2,SWFFinisher(ResourceManager.fileCollection.getFinisher("window1")),false,param4 != VideoElement.CLASS_COMMANDER,false,param4 != VideoElement.CLASS_COMMANDER,false,false,SimpleWindow.SLOT_TYPE_NO_SLOT,true,"comb02_std.png","comb02_hover.png",SimpleWindow.WINDOW_TYPE_NORMAL,false);
         this.videoID = param3;
         this.videoClassID = param4;
         this.factionID = param7;
         this.align = param5;
         this.showButtons = param6;
      }
      
      public function init() : void
      {
         this.simpleContainer = new SimpleContainer(guiManager,SimpleContainer.CLASS_DEFAULT);
         this.videoElement = new VideoElement(this.videoID,this.videoClassID,this.factionID);
         this.simpleContainer.addElement(this.videoElement);
         this.textAreaElement = new TextAreaElement(238,125,TextFormatAlign.LEFT);
         this.simpleContainer.addElement(this.textAreaElement,SimpleContainer.ALIGN_HORIZONTAL);
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         if(this.showButtons)
         {
            this.fasterButton = new ButtonElement(ButtonElement.TYPE_TUTORIAL_FASTER,BPLocale.getText("video_btn_showAll"),_loc1_.getEmbededMovieClip("button1"));
            this.fasterButton.addEventListener(MouseEvent.CLICK,this.handleFasterButtonClick);
            this.fasterButton.x = this.textAreaElement.textArea.width + this.videoElement.border.width - this.fasterButton.width;
            this.fasterButton.y = this.videoElement.border.height - this.fasterButton.height;
            this.fasterButton.visible = false;
            this.simpleContainer.addElement(this.fasterButton,SimpleContainer.NO_ALIGN);
            this.continueButton = new ButtonElement(ButtonElement.TYPE_TUTORIAL_CONTINUE,"",_loc1_.getEmbededMovieClip("button1"));
            this.continueButton.addEventListener(MouseEvent.CLICK,this.handleContinueButtonClick);
            this.simpleContainer.addElement(this.continueButton,SimpleContainer.NO_ALIGN);
            this.continueButton.y = this.videoElement.border.height - this.continueButton.height;
            this.continueButton.visible = false;
            this.updateContinueButtonLabel();
         }
         this.addContainer(this.simpleContainer);
         this.simpleContainer.x = 15;
         this.simpleContainer.y = 35;
         var _loc2_:Point = dimensions[0];
         var _loc3_:int = _loc2_.x;
         var _loc4_:int = _loc2_.y;
         switch(this.align)
         {
            case "n":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc3_ / 2;
               this.startY = -_loc4_ - 100;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc3_ / 2;
               this.targetY = 5;
               break;
            case "ne":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = 5;
               this.targetX = ScreenManager.getScreenWidth() - _loc3_ - 30;
               this.targetY = 5;
               break;
            case "e":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = ScreenManager.getHalfScreenHeight() - _loc4_ / 2;
               this.targetX = ScreenManager.getScreenWidth() - _loc3_ - 30;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc4_ / 2;
               break;
            case "se":
               this.startX = ScreenManager.getScreenWidth() + 10;
               this.startY = ScreenManager.getScreenHeight() - _loc4_ - 30;
               this.targetX = ScreenManager.getScreenWidth() - _loc3_ - 30;
               this.targetY = ScreenManager.getScreenHeight() - _loc4_ - 30;
               break;
            case "s":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc3_ / 2;
               this.startY = ScreenManager.getScreenHeight() - 10;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc3_ / 2;
               this.targetY = ScreenManager.getScreenHeight() - _loc4_ - 30;
               break;
            case "sw":
               this.startX = -_loc3_ - 10;
               this.startY = ScreenManager.getScreenHeight() - _loc4_ - 30;
               this.targetX = 5;
               this.targetY = ScreenManager.getScreenHeight() - _loc4_ - 30;
               break;
            case "w":
               this.startX = -_loc3_ - 10;
               this.startY = ScreenManager.getHalfScreenHeight() - _loc4_ / 2;
               this.targetX = 5;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc4_ / 2;
               break;
            case "nw":
               this.startX = -_loc3_ - 10;
               this.startY = 5;
               this.targetX = 5;
               this.targetY = 5;
               break;
            case "c":
               this.startX = ScreenManager.getHalfScreenWidth() - _loc3_ / 2;
               this.startY = -_loc4_ - 100;
               this.targetX = ScreenManager.getHalfScreenWidth() - _loc3_ / 2;
               this.targetY = ScreenManager.getHalfScreenHeight() - _loc4_ / 2;
         }
         this.x = this.startX;
         this.y = this.startY;
         ScreenManager.getWindowLayer().addChild(this);
      }
      
      private function updateContinueButtonLabel() : void
      {
         var _loc1_:String = "label_close";
         if(this.languageKeys.length > 0)
         {
            _loc1_ = "video_btn_continue";
         }
         this.continueButton.labelText = BPLocale.getText(_loc1_);
         this.continueButton.x = this.textAreaElement.textArea.width + this.videoElement.border.width - this.continueButton.width;
      }
      
      public function attemptToShow() : void
      {
         this.valid = true;
         var _loc1_:String = VideoElement.getContentResKey(this.videoClassID,this.videoID);
         if(ResourceManager.fileCollection.isLoaded(_loc1_))
         {
            this.show();
         }
         else
         {
            ResourceManager.fileCollection.load(_loc1_,this.handleClipLoaded);
         }
      }
      
      private function handleClipLoaded(param1:SWFFinisher = null) : void
      {
         if(this.valid)
         {
            this.show();
         }
      }
      
      private function show() : void
      {
         this.init();
         this.x = this.startX;
         this.y = this.startY;
         TweenLite.to(this,this.scrollSpeed,{
            "x":this.targetX,
            "y":this.targetY,
            "onComplete":this.handleShowComplete
         });
      }
      
      public function hide() : void
      {
         this.valid = false;
         this.x = this.targetX;
         this.y = this.targetY;
         TweenLite.to(this,this.scrollSpeed,{
            "ease":Linear.easeNone,
            "x":this.startX,
            "y":this.startY,
            "onComplete":this.handleHideComplete
         });
         this.videoElement.interference.alpha = 1;
         this.noiseChannel = AudioManager.playSoundEffect(42);
         TweenMax.delayedCall(0.25,this.stopSound);
      }
      
      private function stopSound() : void
      {
         if(this.noiseChannel != null)
         {
            AudioManager.removeLoop(this.noiseChannel);
         }
      }
      
      private function handleHideComplete() : void
      {
         this.simpleContainer.removeAllElements();
         this.videoElement.cleanup();
         this.cleanup();
         this.removeLogWriter();
         guiManager.deleteWindow(this.classID);
         guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.USER_INTERFACE,[ServerCommands.VIDEO_WINDOW,ServerCommands.WINDOW_DESTROYED,this.classID]);
      }
      
      private function startLogTimer(param1:int) : void
      {
         this.removeLogWriter();
         this.logWriter = new Timer(param1,0);
         this.logWriter.addEventListener(TimerEvent.TIMER,this.handleLogWriterTick);
         this.logWriter.start();
      }
      
      private function handleLogWriterTick(param1:TimerEvent) : void
      {
         var _loc5_:int = 0;
         if(this.logMessage.isCompleted())
         {
            this.removeLogWriter();
            if(this.showButtons)
            {
               this.fasterButton.visible = false;
               this.updateContinueButtonLabel();
               this.continueButton.visible = true;
            }
            return;
         }
         var _loc2_:* = "";
         var _loc3_:String = this.logMessage.getPartialMessage(2);
         var _loc4_:String = _loc3_.charAt(_loc3_.length - 1);
         if(_loc4_ == "<")
         {
            _loc5_ = 0;
            while(_loc4_ != ">")
            {
               if(_loc5_ > 20)
               {
                  break;
               }
               _loc3_ = this.logMessage.getPartialMessage(1);
               _loc4_ = _loc3_.charAt(_loc3_.length - 1);
               _loc2_ = _loc2_ + _loc3_ + "\n";
               _loc5_++;
            }
         }
         _loc2_ = _loc2_ + _loc3_ + "\n";
         if(this.logCharIndex % Main.getRandomCount(1,6) == 0)
         {
            AudioManager.playSoundEffect(48);
         }
         ++this.logCharIndex;
         this.textAreaElement.textArea.htmlText = _loc2_;
         this.textAreaElement.textArea.verticalScrollPosition = this.textAreaElement.textArea.maxVerticalScrollPosition;
      }
      
      private function handleShowComplete() : void
      {
         this.videoElement.interference.alpha = 0.1;
         this.noiseChannel = AudioManager.playSoundEffect(42);
         TweenMax.delayedCall(0.25,this.stopSound);
         this.startTextWriter();
      }
      
      public function startTextWriter() : void
      {
         if(this.languageKeys.length == 0)
         {
            return;
         }
         var _loc1_:String = BPLocale.getText(this.languageKeys[0]);
         _loc1_ = this.replaceHTML(_loc1_);
         this.setText(_loc1_);
         this.languageKeys.shift();
         if(this.showButtons)
         {
            this.fasterButton.visible = true;
            this.continueButton.visible = false;
         }
      }
      
      private function replaceHTML(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:Array = PatternManager.videoWindowColorPatterns;
         for(_loc3_ in _loc2_)
         {
            param1 = param1.replace(new RegExp("<" + _loc3_ + ">","g"),"<font color=\'#" + _loc2_[_loc3_] + "\'>");
            param1 = param1.replace(new RegExp("</" + _loc3_ + ">","g"),"</font>");
         }
         return param1;
      }
      
      public function setText(param1:String) : void
      {
         this.logCharIndex = 0;
         this.logMessage = new LogMessage(param1);
         this.startLogTimer(25);
      }
      
      private function handleContinueButtonClick(param1:MouseEvent) : void
      {
         this.nextPage();
      }
      
      public function nextPage() : void
      {
         if(this.languageKeys.length != 0)
         {
            this.startTextWriter();
         }
         else
         {
            guiManager.removeVideoWindow(classID);
         }
      }
      
      private function handleFasterButtonClick(param1:MouseEvent) : void
      {
         this.removeLogWriter();
         this.textAreaElement.textArea.htmlText = this.logMessage.getMessage();
         this.textAreaElement.textArea.verticalScrollPosition = this.textAreaElement.textArea.maxVerticalScrollPosition;
         this.fasterButton.visible = false;
         this.updateContinueButtonLabel();
         this.continueButton.visible = true;
      }
      
      private function removeLogWriter() : void
      {
         if(this.logWriter != null)
         {
            this.logWriter.stop();
            this.logWriter.removeEventListener(TimerEvent.TIMER,this.handleLogWriterTick);
            this.logWriter = null;
         }
      }
   }
}

