# python -m json.tool < scoutsuite.json > prettifer.json

require 'json'
require 'erb'

Dir.mkdir('./output') unless File.exists?('./output')
services = ["acm", "awslambda", "cloudformation", "cloudtrail", "cloudwatch", "config", "directconnect", "dynamodb", "ec2", "efs", "elasticache", "elb", "elbv2", "emr", "iam", "kms", "rds", "redshift", "route53", "s3", "secretsmanager", "ses", "sns", "sqs", "vpc"]
file = File.read('aws-formatted.json')
data = JSON.parse(file)
@toc = []
services.each { | aws_service |
    @toc.push('title-'+aws_service)
    data["services"][aws_service]["findings"].each do | item |
        ary2hash = item[1].to_h
        if ary2hash["flagged_items"] > 0
            @level = ary2hash["level"].to_s
            @checked_items = ary2hash["checked_items"].to_s
            @flagged_items = ary2hash["flagged_items"].to_s
            @description = ary2hash["description"].to_s
            @rationale = ary2hash["rationale"].to_s
            @remediation = ary2hash["remediation"].to_s
            @references = ary2hash["references"].to_s
            # Push item to table of contents array
            @toc.push(@description)
            @toc.push(@level)
            # Open table template for data insertion
            template = File.open('table.html.erb',"r:UTF-8",&:read)
            if @references.include? '["'
                @references = @references.delete_prefix('["')
                @references = @references.delete_suffix('"]')
            end
            # Write data to html file
            File.open('./output/'+@level+'-'+item[0]+'.html', 'w') do | f |
                f.write(ERB.new(template).result)
                f.close
            end
        end
        # Write data to TOC html file
        toc_template = File.open('toc.html.erb',"r:UTF-8",&:read)
        puts ERB.new(toc_template).result
        File.open('./output/'+'toc.html', 'w') do | x |
            x.write(ERB.new(toc_template).result)
        end
    end
}