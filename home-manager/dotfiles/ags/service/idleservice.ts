import { sh } from "lib/utils"

type Profile = "Performance" | "Balanced" | "Quiet"
type Mode = "Hybrid" | "Integrated"

class InhibitorService extends Service {
    static {
        Service.register(this, {}, {
            "status": ['bool','rw'],
        })
    }
    
    status = false;

    get status() {
      return this.status;
    }

    set status() {
	    Utils.exec('matcha -t');
	    this.status = !this.status
    }

       constructor() {
        super()	
  }
}

export default new InhibitorService;
