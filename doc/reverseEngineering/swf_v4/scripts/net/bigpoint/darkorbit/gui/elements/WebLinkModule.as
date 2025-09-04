package net.bigpoint.darkorbit.gui.elements
{
   import com.bigpoint.utils.BPLocale;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class WebLinkModule extends SimpleElement
   {
      
      private var guiManager:GuiManager;
      
      private var type:int;
      
      private var languageKey:String;
      
      private var url:String;
      
      private var module:MovieClip;
      
      public function WebLinkModule(param1:GuiManager, param2:int, param3:String, param4:String, param5:MovieClip)
      {
         super(SimpleElement.TYPE_WEBLINK_MODULE);
         this.guiManager = param1;
         this.type = param2;
         this.languageKey = param3;
         this.url = param4;
         this.module = param5;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:TextField = this.module["labelText"];
         _loc1_.defaultTextFormat = new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215);
         _loc1_.embedFonts = Styles.logEmbed;
         _loc1_.height = Styles.logFontHeight + 5;
         _loc1_.text = BPLocale.getText(this.languageKey);
         _loc1_.mouseEnabled = false;
         this.module["icons"].gotoAndStop(this.type);
         this.module.addEventListener(MouseEvent.CLICK,this.onButtonClicked);
         this.module.buttonMode = true;
         this.addChild(this.module);
      }
      
      private function onButtonClicked(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("referToURL",Settings.dynamicHost + this.url);
         }
      }
      
      public function cleanup() : void
      {
         this.module.removeEventListener(MouseEvent.CLICK,this.onButtonClicked);
      }
   }
}

