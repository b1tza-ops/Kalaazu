package net.bigpoint.darkorbit.groupsystem
{
   public class Group
   {
      
      public static const INVITATION_BEHAVIOR_BOSS_ONLY:int = 0;
      
      public static const INVITATION_BEHAVIOR_FREE_FOR_ALL:int = 1;
      
      public static const LOOT_MODE_RANDOM:int = 1;
      
      public static const LOOT_MODE_NEED_BEFORE_GREED:int = 2;
      
      public static const LOOT_MODE_WYTIWYG:int = 3;
      
      private var _id:int;
      
      private var _sizeCurrent:int;
      
      private var _sizeMax:int;
      
      private var _invitationBehavior:int;
      
      private var _lootMode:int;
      
      private var _members:Array = [];
      
      private var _heroIsBoss:Boolean;
      
      public function Group()
      {
         super();
      }
      
      public function getMemberByID(param1:int) : GroupMember
      {
         var _loc2_:GroupMember = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._members.length)
         {
            if(GroupMember(this._members[_loc3_]).id == param1)
            {
               _loc2_ = GroupMember(this._members[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function addMember(param1:GroupMember) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._members.length)
         {
            if(GroupMember(this._members[_loc2_]).id == param1.id)
            {
               this._members.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this._members.push(param1);
      }
      
      public function removeMember(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._members.length)
         {
            if(GroupMember(this._members[_loc2_]).id == param1)
            {
               this._members.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function init(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this._id = param1;
         this._sizeCurrent = param2;
         this._sizeMax = param3;
         this._invitationBehavior = param4;
         this._lootMode = param5;
      }
      
      public function get sizeCurrent() : int
      {
         return this._sizeCurrent;
      }
      
      public function set sizeCurrent(param1:int) : void
      {
         this._sizeCurrent = param1;
      }
      
      public function get sizeMax() : int
      {
         return this._sizeMax;
      }
      
      public function get invitationBehavior() : int
      {
         return this._invitationBehavior;
      }
      
      public function set invitationBehavior(param1:int) : void
      {
         this._invitationBehavior = param1;
      }
      
      public function get lootMode() : int
      {
         return this._lootMode;
      }
      
      public function set lootMode(param1:int) : void
      {
         this._lootMode = param1;
      }
      
      public function get members() : Array
      {
         return this._members;
      }
      
      public function set members(param1:Array) : void
      {
         this._members = param1;
      }
      
      public function get heroIsBoss() : Boolean
      {
         return this._heroIsBoss;
      }
      
      public function set heroIsBoss(param1:Boolean) : void
      {
         this._heroIsBoss = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}

