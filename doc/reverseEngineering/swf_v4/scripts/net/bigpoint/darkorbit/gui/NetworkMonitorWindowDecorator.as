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
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class NetworkMonitorWindowDecorator
   {
      
      private var guiManager:GuiManager;
      
      private var uiResources:SWFFinisher;
      
      public var playersLeft:int = 0;
      
      public function NetworkMonitorWindowDecorator(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
         this.uiResources = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         var _loc2_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_LOG);
         var _loc3_:SimpleElement = new SimpleElement(SimpleElement.CONNECTION_STATUS);
         var _loc4_:TextField = this.returnFormattedTextField();
         _loc4_.text = BPLocale.getText("label_conn_status") + this.guiManager.getMain().getConnectionManager().xmlSocket.connected;
         _loc3_.addChild(_loc4_);
         _loc3_.y = 10;
         _loc2_.addElement(_loc3_);
         var _loc5_:SimpleElement = new SimpleElement(SimpleElement.CURRENT_IP);
         var _loc6_:TextField = this.returnFormattedTextField();
         _loc6_.text = BPLocale.getText("label_next_ip") + Settings.defaultGameServer;
         _loc5_.addChild(_loc6_);
         _loc5_.y = 10;
         _loc2_.addElement(_loc5_);
         var _loc7_:SimpleElement = new SimpleElement(SimpleElement.NEXT_IP);
         var _loc8_:TextField = this.returnFormattedTextField();
         _loc8_.text = BPLocale.getText("label_next_ip").replace(/%NEXT_IP%/,BPLocale.getText("label_not_set"));
         _loc7_.addChild(_loc8_);
         _loc7_.y = 15;
         _loc2_.addElement(_loc7_);
         var _loc9_:SimpleElement = new SimpleElement(SimpleElement.CURRENT_MAP);
         var _loc10_:TextField = this.returnFormattedTextField();
         _loc10_.text = BPLocale.getText("label_cur_map").replace(/%CUR_MAP%/,this.guiManager.getMain().screenManager.map.getMapID());
         _loc9_.addChild(_loc10_);
         _loc9_.y = 20;
         _loc2_.addElement(_loc9_);
         var _loc11_:SimpleElement = new SimpleElement(SimpleElement.NEXT_MAP);
         var _loc12_:TextField = this.returnFormattedTextField();
         _loc12_.text = BPLocale.getText("label_next_map").replace(/%NEXT_MAP%/,this.guiManager.getMain().screenManager.map.getMapID());
         _loc11_.addChild(_loc12_);
         _loc11_.y = 25;
         _loc2_.addElement(_loc11_);
         var _loc13_:SimpleElement = new SimpleElement(SimpleElement.CURRENT_PORT);
         var _loc14_:TextField = this.returnFormattedTextField();
         _loc14_.text = BPLocale.getText("label_cur_port").replace(/%CUR_PORT%/,this.guiManager.getMain().getConnectionManager().port);
         _loc13_.addChild(_loc14_);
         _loc13_.y = 30;
         _loc2_.addElement(_loc13_);
         var _loc15_:SimpleElement = new SimpleElement(SimpleElement.NUMBER_OF_TRIES);
         var _loc16_:TextField = this.returnFormattedTextField();
         _loc16_.text = BPLocale.getText("label_num_tries").replace(/%NUM_TRIES%/,BPLocale.getText("label_not_set"));
         _loc15_.addChild(_loc16_);
         _loc15_.y = 35;
         _loc2_.addElement(_loc15_);
         var _loc17_:SimpleElement = new SimpleElement(SimpleElement.CONNECT_PENDING_STATUS);
         var _loc18_:TextField = this.returnFormattedTextField();
         _loc18_.text = BPLocale.getText("label_conn_pending").replace(/%CONN_PENDING%/,BPLocale.getText("label_not_set"));
         _loc17_.addChild(_loc18_);
         _loc17_.y = 40;
         _loc2_.addElement(_loc17_);
         param1.addContainer(_loc2_);
         _loc2_.x = 20;
         _loc2_.y = 20;
      }
      
      private function returnFormattedTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         _loc1_.defaultTextFormat = Styles.logFmt;
         _loc1_.wordWrap = false;
         _loc1_.embedFonts = Styles.logEmbed;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         return _loc1_;
      }
   }
}

