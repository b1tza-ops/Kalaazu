package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   
   public class JackpotBattleWindowDecorator
   {
      
      private var guiManager:GuiManager;
      
      private var uiResources:SWFFinisher;
      
      public var playersLeft:int = 0;
      
      public function JackpotBattleWindowDecorator(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
         this.uiResources = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         var _loc2_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_LOG);
         var _loc3_:TextField = new TextField();
         _loc3_.antiAliasType = AntiAliasType.ADVANCED;
         _loc3_.defaultTextFormat = Styles.logFmt;
         _loc3_.wordWrap = false;
         _loc3_.embedFonts = Styles.logEmbed;
         _loc3_.text = BPLocale.getText("label_players_left").replace(/%PLAYERS_REMAINING%/,this.playersLeft.toString());
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         var _loc4_:SimpleElement = new SimpleElement(SimpleElement.TYPE_LOG_TEXTAREA);
         _loc4_.addChild(_loc3_);
         _loc2_.addElement(_loc4_);
         _loc2_.x = 10;
         _loc2_.y = 23;
         param1.addContainer(_loc2_);
      }
   }
}

