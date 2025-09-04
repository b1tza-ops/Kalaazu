package net.bigpoint.darkorbit.gui
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class GlobalNotificationView extends Sprite
   {
      
      private static const PADDING_Y:int = 6;
      
      private var messageBuffer:Array = [];
      
      private var offset:int = 16;
      
      private var _itemWidth:int;
      
      private var _displayTime:int;
      
      public function GlobalNotificationView(param1:int = 500, param2:int = 5)
      {
         super();
         this._displayTime = param2;
         this._itemWidth = param1;
      }
      
      public function addMessage(param1:String) : void
      {
         var _loc2_:GlobalNotification = new GlobalNotification(param1,this._itemWidth,this._displayTime);
         _loc2_.y = this.offset + PADDING_Y + _loc2_.height;
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         this.messageBuffer.push(_loc2_);
         this.update();
      }
      
      private function handleItemRemoved(param1:Event) : void
      {
         var _loc2_:GlobalNotification = GlobalNotification(param1.target);
         var _loc3_:int = int(this.messageBuffer.length - 1);
         while(_loc3_ > -1)
         {
            if(_loc2_ == GlobalNotification(this.messageBuffer[_loc3_]))
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
         var _loc1_:GlobalNotification = null;
         if(this.messageBuffer.length > 0)
         {
            _loc1_ = this.messageBuffer[0] as GlobalNotification;
            if(!contains(_loc1_))
            {
               _loc1_.addEventListener(InstantMessageItem.HANDLE_FADEOUT_COMPLETE,this.handleItemRemoved);
               addChild(_loc1_);
               _loc1_.show();
               _loc1_.moveTo(this.offset);
            }
         }
      }
      
      public function get itemWidth() : int
      {
         return this._itemWidth;
      }
   }
}

