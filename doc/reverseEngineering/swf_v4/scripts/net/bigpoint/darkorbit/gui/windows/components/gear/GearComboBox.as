package net.bigpoint.darkorbit.gui.windows.components.gear
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.Bitmap;
   import flash.display.LineScaleMode;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   
   public class GearComboBox extends Sprite
   {
      
      public static const COMBOBOX_CLICK:String = "COMBOBOX_CLICK";
      
      private var iconContainer:Sprite;
      
      private var comboboxHeaderContainer:Sprite;
      
      public var arrowButton:MovieClip;
      
      public var bodyWidth:int = 110;
      
      public var bodyHeight:int = 12;
      
      private var gearTextfield:TextField;
      
      public function GearComboBox()
      {
         super();
      }
      
      public function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc2_:Bitmap = _loc1_.getEmbededBitmap("gear_bg.png");
         this.arrowButton = _loc1_.getEmbededMovieClip("comboButton");
         this.iconContainer = new Sprite();
         this.iconContainer.addChild(_loc2_);
         addChild(this.iconContainer);
         this.comboboxHeaderContainer = new Sprite();
         this.comboboxHeaderContainer.graphics.beginFill(3355443,1);
         this.comboboxHeaderContainer.graphics.lineStyle(0.1,10066329,1,true,LineScaleMode.NORMAL);
         this.comboboxHeaderContainer.graphics.drawRect(0,0,this.bodyWidth,this.bodyHeight);
         this.comboboxHeaderContainer.graphics.endFill();
         this.comboboxHeaderContainer.x = this.iconContainer.width;
         this.comboboxHeaderContainer.y = 8;
         var _loc3_:TextFormat = new TextFormat(Styles.plainBigFmt.font,10,16777215,false);
         this.gearTextfield = new TextField();
         this.gearTextfield.antiAliasType = AntiAliasType.ADVANCED;
         this.gearTextfield.embedFonts = true;
         this.gearTextfield.autoSize = TextFieldAutoSize.LEFT;
         this.gearTextfield.defaultTextFormat = _loc3_;
         this.gearTextfield.setTextFormat(_loc3_);
         this.gearTextfield.width = this.bodyWidth;
         this.gearTextfield.height = 12;
         this.comboboxHeaderContainer.addChild(this.gearTextfield);
         addChild(this.comboboxHeaderContainer);
         this.arrowButton.gotoAndStop(1);
         this.arrowButton.x = this.comboboxHeaderContainer.x + this.comboboxHeaderContainer.width + 2;
         this.arrowButton.y = this.comboboxHeaderContainer.y - 2;
         addChild(this.arrowButton);
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(0,0);
         _loc4_.graphics.drawRect(0,0,this.width,this.height);
         _loc4_.graphics.endFill();
         _loc4_.useHandCursor = true;
         _loc4_.buttonMode = true;
         _loc4_.addEventListener(MouseEvent.CLICK,this.handleComboButtonClick);
         this.addChild(_loc4_);
      }
      
      private function handleComboButtonClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(COMBOBOX_CLICK));
      }
      
      public function setIcon(param1:Bitmap) : void
      {
         if(this.iconContainer.numChildren > 1)
         {
            this.iconContainer.removeChildAt(1);
         }
         if(param1 != null)
         {
            param1.x = (this.iconContainer.width - param1.width) * 0.5;
            param1.y = (this.iconContainer.height - param1.height) * 0.5;
            this.iconContainer.addChild(param1);
         }
      }
      
      public function setSelectedText(param1:String) : void
      {
         this.gearTextfield.text = param1;
      }
   }
}

