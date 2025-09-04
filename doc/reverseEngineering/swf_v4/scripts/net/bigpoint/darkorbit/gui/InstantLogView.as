package net.bigpoint.darkorbit.gui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class InstantLogView extends Sprite
   {
      
      public static const logger:ILogger = Log.getLogger("InstantLogView");
      
      private static const PADDING_Y:int = 6;
      
      private var messageBuffer:Array = [];
      
      private var offset:int = 0;
      
      private var _itemWidth:int;
      
      private var _maxEntries:int;
      
      private var _displayTime:int;
      
      public function InstantLogView(param1:int = 400, param2:int = 5, param3:int = 10)
      {
         super();
         this._itemWidth = param1;
         this._maxEntries = param2;
         this._displayTime = param3;
      }
      
      public function addMessage(param1:String, param2:LogMessageProfile) : void
      {
         var _loc3_:InstantMessageItem = new InstantMessageItem(param1,this._itemWidth,param2.displayTime);
         _loc3_.y = this.offset + _loc3_.height + PADDING_Y;
         _loc3_.mouseEnabled = false;
         _loc3_.mouseChildren = false;
         if(param2.highPriority)
         {
            _loc3_.addEventListener(InstantMessageItem.HANDLE_FADEOUT_COMPLETE,this.handleHighPriorityItemRemoved);
            addChild(_loc3_);
         }
         else
         {
            this.messageBuffer.push(_loc3_);
            _loc3_.addEventListener(InstantMessageItem.HANDLE_FADEOUT_COMPLETE,this.handleItemRemoved);
            addChild(_loc3_);
         }
         this.update();
      }
      
      private function handleHighPriorityItemRemoved(param1:Event) : void
      {
         var _loc2_:InstantMessageItem = InstantMessageItem(param1.target);
         _loc2_.removeEventListener(InstantMessageItem.HANDLE_FADEOUT_COMPLETE,this.handleHighPriorityItemRemoved);
         _loc2_.dispose();
         this.update();
      }
      
      private function handleItemRemoved(param1:Event) : void
      {
         var _loc2_:InstantMessageItem = InstantMessageItem(param1.target);
         var _loc3_:int = int(this.messageBuffer.length - 1);
         while(_loc3_ > -1)
         {
            if(_loc2_ == InstantMessageItem(this.messageBuffer[_loc3_]))
            {
               this.messageBuffer.splice(_loc3_,1);
               this.update();
               return;
            }
            _loc3_--;
         }
      }
      
      private function update() : void
      {
         var _loc1_:InstantMessageItem = null;
         var _loc3_:InstantMessageItem = null;
         while(this.messageBuffer.length > this._maxEntries)
         {
            _loc1_ = InstantMessageItem(this.messageBuffer[0]);
            _loc1_.removeEventListener(InstantMessageItem.HANDLE_FADEOUT_COMPLETE,this.handleItemRemoved);
            _loc1_.dispose();
            this.messageBuffer.shift();
         }
         this.offset = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.numChildren)
         {
            _loc3_ = InstantMessageItem(this.getChildAt(_loc2_));
            _loc3_.moveTo(this.offset);
            this.offset += _loc3_.height + PADDING_Y;
            _loc2_++;
         }
      }
      
      public function get itemWidth() : int
      {
         return this._itemWidth;
      }
   }
}

