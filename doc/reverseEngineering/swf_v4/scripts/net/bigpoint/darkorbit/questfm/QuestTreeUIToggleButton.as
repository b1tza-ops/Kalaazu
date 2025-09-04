package net.bigpoint.darkorbit.questfm
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class QuestTreeUIToggleButton extends MovieClip implements IQuestTreeUIClip
   {
      
      private var _standardClip:QuestTreeUIClip;
      
      private var _toggleClip:QuestTreeUIClip;
      
      private var _currentClip:QuestTreeUIClip;
      
      private var _selected:Boolean;
      
      private var _state:int = 0;
      
      private var _type:int;
      
      private var _id:int;
      
      public function QuestTreeUIToggleButton()
      {
         super();
      }
      
      public function init(param1:BitmapData, param2:BitmapData, param3:BitmapData) : void
      {
         this._standardClip = new QuestTreeUIClip();
         this._standardClip.init(param1,param2,param3);
         this._toggleClip = new QuestTreeUIClip();
         this._toggleClip.init(param1,param2,param3);
         this._currentClip = this._standardClip;
         addChild(this._currentClip);
      }
      
      public function setToggleClips(param1:BitmapData, param2:BitmapData, param3:BitmapData) : void
      {
         if(contains(this._toggleClip))
         {
            removeChild(this._toggleClip);
         }
         this._toggleClip = new QuestTreeUIClip();
         this._toggleClip.init(param1,param2,param3);
         this._toggleClip.state = this._state;
         if(this._selected)
         {
            this._currentClip = this._toggleClip;
            addChild(this._toggleClip);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(param1 != this._selected)
         {
            removeChild(this._currentClip);
            this._selected = param1;
            if(this._selected)
            {
               this._currentClip = this._toggleClip;
            }
            else
            {
               this._currentClip = this._standardClip;
            }
            addChild(this._currentClip);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set state(param1:int) : void
      {
         this._state = param1;
         this._standardClip.state = param1;
         this._toggleClip.state = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
         this._standardClip.id = param1;
         this._toggleClip.id = param1;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
         this._standardClip.type = param1;
         this._toggleClip.type = param1;
      }
   }
}

