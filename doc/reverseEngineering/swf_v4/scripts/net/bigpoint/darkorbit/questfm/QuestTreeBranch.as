package net.bigpoint.darkorbit.questfm
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class QuestTreeBranch
   {
      
      private var _questBaseObject:IQuestBaseObject;
      
      private var _uiClip:IQuestTreeUIClip;
      
      private var _descriptionClip:MovieClip;
      
      private var _descriptionLabel:TextField;
      
      private var _iconsClip:MovieClip;
      
      private var _valuesClip:MovieClip;
      
      private var _valuesLabel:TextField;
      
      private var _branches:Array = [];
      
      private var _type:int;
      
      private var _visible:Boolean;
      
      private var _expanded:Boolean;
      
      private var _runstate:Boolean;
      
      private var _visibility:int;
      
      public function QuestTreeBranch(param1:int)
      {
         super();
         if(param1 == QuestTreeBranchType.CASE)
         {
            this._type = QuestTreeBranchType.CASE;
         }
         else
         {
            this._type = QuestTreeBranchType.CONDITION;
         }
      }
      
      public function addBranch(param1:QuestTreeBranch) : void
      {
         this._branches.push(param1);
      }
      
      public function setUi(param1:MovieClip, param2:IQuestTreeUIClip, param3:MovieClip = null, param4:MovieClip = null) : void
      {
         this._descriptionClip = param1;
         this._descriptionLabel = TextField(this._descriptionClip["txtLabel"]);
         this._uiClip = param2;
         this._valuesClip = param3;
         this._iconsClip = param4;
         if(this._valuesClip != null)
         {
            this._valuesLabel = TextField(this._valuesClip["txtLabel"]);
            this._valuesLabel.x += 8;
         }
         if(this._iconsClip != null)
         {
            this._descriptionLabel.width = 48;
            this._iconsClip.x = 56;
         }
         this._visible = true;
         this._expanded = true;
      }
      
      public function set questBaseObject(param1:IQuestBaseObject) : void
      {
         this._questBaseObject = param1;
      }
      
      public function get uiClip() : IQuestTreeUIClip
      {
         return this._uiClip;
      }
      
      public function get descriptionClip() : MovieClip
      {
         return this._descriptionClip;
      }
      
      public function get valuesClip() : MovieClip
      {
         return this._valuesClip;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get questBaseObject() : IQuestBaseObject
      {
         return this._questBaseObject;
      }
      
      public function get descriptionLabel() : TextField
      {
         return this._descriptionLabel;
      }
      
      public function get valuesLabel() : TextField
      {
         return this._valuesLabel;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
         if(this._descriptionClip != null)
         {
            this._descriptionClip.visible = this._visible;
         }
         if(this._uiClip != null)
         {
            this._uiClip.visible = this._visible;
         }
         if(this._valuesClip != null)
         {
            this._valuesClip.visible = this._visible;
         }
         if(this._iconsClip != null)
         {
            this._iconsClip.visible = this._visible;
         }
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public function get runstate() : Boolean
      {
         return this._runstate;
      }
      
      public function set runstate(param1:Boolean) : void
      {
         if(this._runstate != param1)
         {
            this._runstate = param1;
         }
      }
      
      public function set expanded(param1:Boolean) : void
      {
         this._expanded = param1;
      }
      
      public function get visibility() : int
      {
         return this._visibility;
      }
      
      public function set visibility(param1:int) : void
      {
         if(this._visibility != param1)
         {
            this._visibility = param1;
         }
      }
      
      public function get iconsClip() : MovieClip
      {
         return this._iconsClip;
      }
   }
}

