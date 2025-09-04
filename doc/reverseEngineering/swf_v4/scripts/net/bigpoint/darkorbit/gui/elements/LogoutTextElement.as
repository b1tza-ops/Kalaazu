package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.utils.BPLocale;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   
   public class LogoutTextElement extends SimpleElement
   {
      
      private var guiManager:GuiManager;
      
      private var textField:TextField = new TextField();
      
      private var countdown:int;
      
      private var timer:Timer;
      
      private var msgTop:String;
      
      private var msgBottom:String;
      
      public function LogoutTextElement(param1:GuiManager)
      {
         super(SimpleElement.TYPE_LOGOUT_TEXT);
         this.guiManager = param1;
         this.init();
      }
      
      public function init() : void
      {
         var _loc1_:Array = BPLocale.getText("msg_logout_seconds").split("%SEC%");
         this.msgTop = _loc1_[0];
         this.msgBottom = _loc1_[1];
         var _loc2_:TextFormat = new TextFormat(Styles.plainBigFmt.font,Styles.plainBigFontHeight,16777215);
         _loc2_.align = TextFormatAlign.CENTER;
         this.textField.defaultTextFormat = _loc2_;
         this.textField.embedFonts = Styles.plainBigEmbed;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.autoSize = TextFieldAutoSize.CENTER;
         this.textField.wordWrap = true;
         this.textField.multiline = true;
         this.textField.width = 200;
         this.updateText();
         this.addChild(this.textField);
         this.timer = new Timer(1000,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
      }
      
      public function startCountdown() : void
      {
         if(Hero.premium || Hero.admin)
         {
            this.countdown = 5;
         }
         else
         {
            this.countdown = 20;
         }
         this.timer.start();
         this.updateText();
      }
      
      public function stopCountdown() : void
      {
         this.timer.stop();
         this.timer.reset();
      }
      
      private function onTimerComplete() : void
      {
         var _loc1_:* = this.guiManager.getGlobalchat();
         if(_loc1_ != null)
         {
            _loc1_.cleanup();
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("bpCloseWindow","");
         }
      }
      
      private function updateText() : void
      {
         this.textField.text = this.msgTop + "\n\n" + this.countdown + "\n\n" + this.msgBottom;
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         if(this.countdown > 0)
         {
            --this.countdown;
            this.updateText();
         }
      }
      
      public function cleanup() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
      }
   }
}

