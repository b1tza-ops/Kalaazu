package net.bigpoint.darkorbit.gui.elements.numericstepper
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.OreTradeModule;
   
   public class TradeModuleNumericStepper extends Sprite
   {
      
      public static const OUT:int = 1;
      
      public static const HOVER:int = 2;
      
      public static const DOWN:int = 3;
      
      public static const INACTIVE:int = 4;
      
      public static const INCREMENT:String = "inc";
      
      public static const DECREMENT:String = "dec";
      
      private var tradeModule:OreTradeModule;
      
      private var amountAfterSaleTextField:TextField;
      
      private var amountToSellTextField:TextField;
      
      private var totalOre:int = -1;
      
      private var amountAfterSale:int = 0;
      
      private var amountToSell:int = 0;
      
      public var moreButton:MovieClip;
      
      public var lessButton:MovieClip;
      
      private var tmpSavedInputValue:String = "";
      
      private var tmpTotalInputValue:String = "";
      
      private var blockMoreButton:Boolean = false;
      
      private var blockLessButton:Boolean = false;
      
      private var incrementUnit:int;
      
      private var orePrice:int = -1;
      
      public function TradeModuleNumericStepper(param1:OreTradeModule)
      {
         super();
         this.tradeModule = param1;
         this.init();
      }
      
      public function getValue() : int
      {
         var _loc1_:int = 0;
         if(this.amountToSellTextField.text.length > 0)
         {
            _loc1_ = int(this.amountToSellTextField.text);
         }
         else
         {
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      public function setIncreaseStep(param1:int) : void
      {
         this.incrementUnit = param1;
      }
      
      public function setOreAmount(param1:int, param2:int) : void
      {
         this.orePrice = param2;
         if(this.totalOre > param1)
         {
            this.amountToSell = 0;
            this.totalOre = param1;
            this.amountAfterSale = param1;
            this.initButtons();
         }
         else
         {
            this.amountToSell = param1 - param1 % this.incrementUnit;
            this.totalOre = param1;
            this.amountAfterSale = this.totalOre - this.amountToSell;
            this.initButtons();
         }
         this.setText(this.amountToSellTextField,String(this.amountToSell));
         this.setText(this.amountAfterSaleTextField,String(this.totalOre));
         this.updateCheck();
      }
      
      public function printOreAmountValues() : void
      {
      }
      
      private function setText(param1:TextField, param2:String) : void
      {
         param1.text = param2;
      }
      
      private function initButtons() : void
      {
         if(this.totalOre == 0 || this.orePrice < 0 || this.totalOre < this.incrementUnit)
         {
            this.blockLessButton = true;
            this.blockMoreButton = true;
            this.setButtonState(this.lessButton,INACTIVE);
            this.setButtonState(this.moreButton,INACTIVE);
            this.removeListeners();
         }
         else
         {
            if(this.totalOre > this.amountToSell && this.totalOre - this.amountToSell >= this.incrementUnit)
            {
               this.blockMoreButton = false;
               this.setButtonState(this.moreButton,OUT);
            }
            if(this.amountToSell == 0)
            {
               this.blockLessButton = true;
               this.setButtonState(this.lessButton,INACTIVE);
            }
            else
            {
               this.blockLessButton = false;
               this.setButtonState(this.lessButton,OUT);
            }
            this.addListeners();
         }
      }
      
      private function init() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc2_:TextFormat = Styles.plainStdFmt;
         _loc2_.align = TextFormatAlign.CENTER;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = new Sprite();
         this.amountAfterSaleTextField = new TextField();
         this.amountAfterSaleTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.amountAfterSaleTextField.defaultTextFormat = _loc2_;
         this.amountAfterSaleTextField.embedFonts = true;
         this.amountAfterSaleTextField.multiline = false;
         this.amountAfterSaleTextField.textColor = 10066329;
         this.amountAfterSaleTextField.setTextFormat(_loc2_);
         this.amountAfterSaleTextField.width = 50;
         this.amountAfterSaleTextField.height = 15;
         this.amountAfterSaleTextField.restrict = "0-9";
         this.amountAfterSaleTextField.maxChars = 6;
         this.amountAfterSaleTextField.y = 1;
         this.amountToSellTextField = new TextField();
         this.amountToSellTextField.type = TextFieldType.INPUT;
         this.amountToSellTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.amountToSellTextField.defaultTextFormat = _loc2_;
         this.amountToSellTextField.embedFonts = true;
         this.amountToSellTextField.multiline = false;
         this.amountToSellTextField.selectable = true;
         this.amountToSellTextField.textColor = 16777215;
         this.amountToSellTextField.setTextFormat(_loc2_);
         this.amountToSellTextField.width = 40;
         this.amountToSellTextField.height = 15;
         this.amountToSellTextField.restrict = "0-9";
         this.amountToSellTextField.maxChars = 6;
         this.amountToSellTextField.y = this.amountAfterSaleTextField.y + this.amountAfterSaleTextField.height;
         this.moreButton = _loc1_.getEmbededMovieClip("numericStepperPlus");
         this.moreButton.y = 17;
         this.moreButton.x = 53;
         this.moreButton.buttonMode = this.moreButton.useHandCursor = true;
         this.setButtonState(this.moreButton,INACTIVE);
         this.lessButton = _loc1_.getEmbededMovieClip("numericStepperMinus");
         this.lessButton.y = 17;
         this.lessButton.buttonMode = this.lessButton.useHandCursor = true;
         this.setButtonState(this.lessButton,INACTIVE);
         _loc4_.x = this.moreButton.width * 0.5;
         _loc4_.y = this.moreButton.height * 0.5;
         _loc4_.addChild(this.moreButton);
         _loc4_.addChild(this.lessButton);
         this.amountToSellTextField.x = this.lessButton.x + this.lessButton.width - 1;
         this.amountAfterSaleTextField.width = _loc4_.width;
         _loc3_.addChild(this.amountToSellTextField);
         _loc3_.addChild(this.amountAfterSaleTextField);
         addChild(_loc4_);
         addChild(_loc3_);
      }
      
      private function handleLessButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.amountAfterSale + this.incrementUnit < this.totalOre)
         {
            _loc2_ = this.getCorrectIncrementUnit(this.amountAfterSale,DECREMENT);
            this.updateGain(this.amountAfterSale + _loc2_);
         }
         else
         {
            this.updateGain(this.totalOre);
         }
      }
      
      private function handleMoreButtonClick(param1:MouseEvent) : void
      {
         if(this.amountAfterSale - this.incrementUnit > 0)
         {
            this.updateGain(this.amountAfterSale - this.incrementUnit);
         }
         else
         {
            this.updateGain(0);
         }
      }
      
      private function getCorrectIncrementUnit(param1:int, param2:String) : int
      {
         var _loc4_:int = 0;
         var _loc3_:int = param1 % this.incrementUnit;
         param1 = this.totalOre - param1;
         if(_loc3_ == 0)
         {
            return this.incrementUnit;
         }
         switch(param2)
         {
            case INCREMENT:
               _loc4_ = _loc3_;
               break;
            case DECREMENT:
               _loc4_ = this.incrementUnit - _loc3_;
         }
         return _loc4_;
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.target);
         if(!this.blockLessButton && _loc2_ == this.lessButton)
         {
            this.setButtonState(_loc2_,OUT);
         }
         else if(!this.blockMoreButton && _loc2_ == this.moreButton)
         {
            this.setButtonState(_loc2_,OUT);
         }
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.target);
         if(!this.blockLessButton && _loc2_ == this.lessButton)
         {
            this.setButtonState(_loc2_,HOVER);
         }
         else if(!this.blockMoreButton && _loc2_ == this.moreButton)
         {
            this.setButtonState(_loc2_,HOVER);
         }
      }
      
      public function deactivateSellAmountTextField() : void
      {
         this.amountToSellTextField.removeEventListener(FocusEvent.FOCUS_IN,this.handleTotalAmountTextfieldFocusIn);
         this.amountToSellTextField.removeEventListener(FocusEvent.FOCUS_OUT,this.handleTotalAmountTextfieldFocusOut);
         this.amountToSellTextField.removeEventListener(Event.CHANGE,this.handleTotalAmountTextfieldChange);
         this.amountToSellTextField.type = TextFieldType.DYNAMIC;
         this.amountToSellTextField.selectable = false;
         this.amountToSellTextField.mouseEnabled = false;
      }
      
      public function activateSellAmountTextField() : void
      {
         this.amountToSellTextField.addEventListener(FocusEvent.FOCUS_IN,this.handleTotalAmountTextfieldFocusIn);
         this.amountToSellTextField.addEventListener(FocusEvent.FOCUS_OUT,this.handleTotalAmountTextfieldFocusOut);
         this.amountToSellTextField.addEventListener(Event.CHANGE,this.handleTotalAmountTextfieldChange);
         this.amountToSellTextField.type = TextFieldType.INPUT;
         this.amountToSellTextField.selectable = true;
         this.amountToSellTextField.mouseEnabled = true;
      }
      
      public function deactivateUpperButton() : void
      {
         this.blockMoreButton = true;
         this.setButtonState(this.moreButton,INACTIVE);
         this.moreButton.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.moreButton.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.moreButton.removeEventListener(MouseEvent.CLICK,this.handleMoreButtonClick);
      }
      
      public function deactivateLowerButton() : void
      {
         this.blockLessButton = true;
         this.setButtonState(this.lessButton,INACTIVE);
         this.lessButton.removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.lessButton.removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.lessButton.removeEventListener(MouseEvent.CLICK,this.handleLessButtonClick);
      }
      
      public function activateUpperButton() : void
      {
         this.blockMoreButton = false;
         this.setButtonState(this.moreButton,OUT);
         this.moreButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.moreButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.moreButton.addEventListener(MouseEvent.CLICK,this.handleMoreButtonClick);
      }
      
      public function activateLowerButton() : void
      {
         this.blockLessButton = false;
         this.setButtonState(this.lessButton,OUT);
         this.lessButton.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.lessButton.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.lessButton.addEventListener(MouseEvent.CLICK,this.handleLessButtonClick);
      }
      
      public function addListeners() : void
      {
         if(!this.moreButton.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.activateUpperButton();
            this.activateLowerButton();
            this.activateSellAmountTextField();
         }
      }
      
      public function removeListeners() : void
      {
         if(this.moreButton.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.deactivateUpperButton();
            this.deactivateLowerButton();
            this.deactivateSellAmountTextField();
            this.amountAfterSale = 0;
         }
      }
      
      private function handleSavedAmountTextfieldChange(param1:Event) : void
      {
         var _loc2_:int = int(TextField(param1.target).text);
         if(_loc2_ > this.totalOre)
         {
            _loc2_ = this.totalOre;
         }
         this.amountAfterSale = _loc2_;
         if(this.tmpSavedInputValue != String(_loc2_))
         {
            this.updateGain(this.amountAfterSale);
         }
      }
      
      private function handleSavedAmountTextfieldFocusOut(param1:FocusEvent) : void
      {
         var _loc2_:TextField = TextField(param1.target);
         if(!_loc2_.text.length > 0)
         {
            this.setText(_loc2_,this.tmpSavedInputValue);
         }
         this.tmpSavedInputValue = "";
      }
      
      private function handleSavedAmountTextfieldFocusIn(param1:FocusEvent) : void
      {
         this.tmpSavedInputValue = TextField(param1.target).text;
         this.setText(TextField(param1.target),"");
      }
      
      private function handleTotalAmountTextfieldFocusIn(param1:FocusEvent) : void
      {
         this.tmpTotalInputValue = TextField(param1.target).text;
         this.setText(TextField(param1.target),"");
      }
      
      private function handleTotalAmountTextfieldChange(param1:Event) : void
      {
         var _loc2_:int = int(TextField(param1.target).text);
         if(_loc2_ > this.totalOre)
         {
            _loc2_ = this.totalOre;
         }
         this.amountAfterSale = this.totalOre - _loc2_;
         if(this.tmpTotalInputValue != String(_loc2_))
         {
            this.updateGain(this.amountAfterSale);
         }
      }
      
      private function handleTotalAmountTextfieldFocusOut(param1:FocusEvent) : void
      {
         var _loc2_:TextField = TextField(param1.target);
         if(!_loc2_.text.length > 0)
         {
            this.setText(_loc2_,this.tmpTotalInputValue);
         }
         this.tmpTotalInputValue = "";
      }
      
      private function setButtonState(param1:MovieClip, param2:int) : void
      {
         param1.gotoAndStop(param2);
      }
      
      private function updateGain(param1:int) : void
      {
         var _loc2_:int = this.totalOre - param1;
         this.amountToSell = _loc2_ - _loc2_ % this.incrementUnit;
         this.amountAfterSale = param1;
         this.setText(this.amountToSellTextField,String(this.amountToSell));
         this.updateCheck();
         dispatchEvent(new NumericStepperEvent(NumericStepperEvent.CHANGE,this.amountToSell));
      }
      
      public function setFinalValueFieldEmpty() : void
      {
         this.setText(this.amountToSellTextField,String(0));
      }
      
      public function updateCheck() : void
      {
         this.blockMoreButton = false;
         this.blockLessButton = false;
         if(this.amountAfterSale < this.incrementUnit || this.orePrice < 0)
         {
            this.blockMoreButton = true;
            this.setButtonState(this.moreButton,INACTIVE);
         }
         else
         {
            this.blockMoreButton = false;
            this.setButtonState(this.moreButton,OUT);
         }
         if(this.totalOre == this.amountAfterSale || this.amountToSell == 0 || this.orePrice < 0)
         {
            this.blockLessButton = true;
            this.setButtonState(this.lessButton,INACTIVE);
         }
         else
         {
            this.blockLessButton = false;
            this.setButtonState(this.lessButton,OUT);
         }
         if(this.orePrice < 0)
         {
            this.setText(this.amountToSellTextField,"");
         }
         this.tradeModule.showSellButton(!this.blockMoreButton || !this.blockLessButton);
      }
      
      public function setRatio(param1:Point) : void
      {
         this.incrementUnit = param1.y;
      }
   }
}

