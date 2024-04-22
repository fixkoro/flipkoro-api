<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class AdminRoleTable extends Seeder
{
    /**
     * Run the database seeders.
     *
     * @return void
     */
    public function run()
    {
        DB::table('admin_roles')->insert([
            'id' => 1,
            'name' => 'Master Admin',
        ]);

        DB::table('admin_roles')->insert([
            'id' => 2,
            'name' => 'Employee',
        ]);
    }
}
