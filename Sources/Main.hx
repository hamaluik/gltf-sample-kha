package;

import kha.Assets;
import kha.System;
import kha.Scheduler;

class Main {
	public static function main() {
        System.init({title: "Sample", width: 800, height: 600}, init);
	}

	static function init() {
        Assets.loadEverything(function() {
            var sample = new Sample();
            Scheduler.addTimeTask(sample.update, 0, 1/60);
            System.notifyOnRender(sample.render);
        });
	}
}