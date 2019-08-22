# the value of `params` is the value of the hash passed to `script_params`
# in the logstash configuration
def register(params)
        # @message = params["message"]
    end

    # the filter method receives an event and must return a list of events.
    # Dropping an event means not including it in the return array,
    # while creating new ones only requires you to add a new instance of
    # LogStash::Event to the returned array
    def filter(event)
        unknown_val = 0
        ka_avl_val = 0
        ka_wmq_val = 0
        ka_eng_val = 0
        ka_oth_val = 0
        hika_mon_val = 0
        hika_mai_val = 0
        hika_tro_val = 0
        hika_rfp_val = 0
        string = event.get("message")
        uniq_ary = string.split(/\t/).group_by{|e| e}.map{|k, v| [k, v.length]}.each.with_index(0){
            |k, i|
            if i == 0
                # 第一欄為設備類型
                event.set("01_device_class", k[0])
            elsif i == 1
                # 第二欄為設備ID
                event.set("02_device_id", k[0])
            else
                if k[0] == ':'
                    unknown_val = unknown_val + k[1]
                elsif k[0] != ''
                    field = k[0].sub(":","_").downcase
                    if field.include? 'avl'
                        ka_avl_val = ka_avl_val + k[1]
                    elsif field.include? 'wmq'
                        ka_wmq_val = ka_wmq_val + k[1]
                    elsif field.include? 'eng'
                        ka_eng_val = ka_eng_val + k[1]
                    elsif field.include? 'rwk' or field.include? 'apw' or field.include? 'rev'
                        ka_oth_val = ka_oth_val + k[1]
                    elsif field.include? 'wmo' or field.include? 'mon' or field.include? 'mng'
                        hika_mon_val = hika_mon_val + k[1]
                    elsif field.include? 'oma' or field.include? 'wma' or field.include? 'mai'
                        hika_mai_val = hika_mai_val + k[1]
                    elsif field.include? 'tbl' or field.include? 'tbs' or field.include? 'una'
                        hika_tro_val = hika_tro_val + k[1]
                    elsif field.include? 'rfp'
                        hika_rfp_val = hika_rfp_val + k[1]
                    else
                        unknown_val = unknown_val + k[1]
                    end
                else 
                  unknown_val = unknown_val + k[1]
                end
            end
        }
        
        event.set("10_ka_avl_val", ka_avl_val)
        event.set("11_ka_wmq_val", ka_wmq_val)
        event.set("12_ka_eng_val", ka_eng_val)
        event.set("13_ka_oth_val", ka_oth_val)
        event.set("14_hika_mon_val", hika_mon_val)
        event.set("15_hika_mai_val", hika_mai_val)
        event.set("16_hika_tro_val", hika_tro_val)
        event.set("17_hika_rfp_val", hika_rfp_val)
        event.set("99_unknown_val", unknown_val)

        path = event.get('path')
        filedate = path[-8, 8]
        if filedate.to_i > 0 and filedate.length == 8
            event.set('filedate', filedate)
        end

        return [event]
    end